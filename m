Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211334;
	b=qsXnzlajXH/1jUy3j8wjWRFmbjR0rcynGqKkHqgPsG0KFa3kQqZbXRm7PVSGArC4rBa0
	 qlJUTFtkeySRiB5o8PTMsSbSX7ukBEwNkGcQ8rUQbrlOD0bTUEnUHKNpX8LP49RQwAY8v
	 whaJvpkqPe1TmmjItu8xrma/Fgcy+M3Zjy5FoKHan44vT7m2opN3qs4FF+OLVGWZelQKq
	 ic+SUUMEnKKFSlgwzsmdpQHSJTF7Dnj1QwbEejZuNSlp29/zz4wRQrJAK2fttyHBDO5rk
	 MI2farydGoVJBug8EHRykNGmE5FGt9AqMXT4dKv5H04IpJS0rrG0Bm6sm1102ToTSjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211334;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=maqxjTjquPvJ1IE9CIcjWaaRtr0q/9DpHYTXwmmkYDg=;
	b=1CGS6pmO7oFgnG9Dr157hOG7PyINFOpS4uTn0SnOuz04pIYeoVuLnWSqX3BlH9SBzTbT
	 rfAsC/hblOz6az6mGQd9I352E4dU689fFpDLwtBjT5PNzhHobnuXuChY/KMJav4o7ny2n
	 HQT6RuZu+VEB0coaRSoT4zayVDRyhg/pT+m7unLGXOZRMPjCh2uO+3Clwun3gPGGMQSFS
	 msixXF2lkDf/t+iEwRTw6P7ZYGoSCjqyu9xIhA4GegONHInrKezWyU7MaHGTmotxwO3mL
	 dZi6Im+F5p49V+CZU4Mxgo64uRIepYbWck+F3+XHXjC1kRcUOr33/NMsdMmcyUqCpmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qqCPjXMk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA827606A31D;
	Wed, 28 Oct 2026 18:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qqCPjXMk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D0B1F01825;
	Wed, 28 Oct 2026 18:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211333;
	bh=maqxjTjquPvJ1IE9CIcjWaaRtr0q/9DpHYTXwmmkYDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qqCPjXMkMeq9TLW1k3l1BCrEK9wKfVd7CRMYxoWdcXNg3YzwxkypLS2FnMbjTsoPg
	 nuwGFlDaBijdmm3SJcBvSMP9GRoQck5Yva982+zH2ScgJS56M/4JEzs6MEjgcAEelm
	 PuQ6+kQppEuL+hBnwVpvAMzXDEWyqPYl6ZBIOQ2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Llamas <cmllamas@google.com>,
	Lee Jones <lee@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 341/571] HID: uhid: convert to hid_safe_input_report()
Date: Wed, 28 Oct 2026 17:58:08 +0100
Message-ID: <20261028170016.108906800@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Llamas <cmllamas@google.com>

[ Upstream commit 63a694c51bf120a37550890b8e7736b4888985e9 ]

Commit 0a3fe972a7cb ("HID: core: Mitigate potential OOB by removing
bogus memset()"), added a check in hid_report_raw_event() to reject
reports if the received data size is smaller than expected. This was
intended to prevent OOB errors by no longer allowing zeroing-out of
shorter reports due to the lack of buffer size information.

However, this leads to regressions in hid_report_raw_event(), where
shorter than expected reports are rejected, even though their buffers
are sufficiently large to be zero-padded.

To solve this issue, Benjamin introduced a safer alternative in commit
206342541fc8 ("HID: core: introduce hid_safe_input_report()"), which
forwards the buffer size and allows hid_report_raw_event() to safely
zero-pad the data.

Convert uhid to use hid_safe_input_report() and pass UHID_DATA_MAX as
the buffer size. This prevents the reported regressions [1], allowing
hid core to zero-pad the shorter reports safely as expected.

Cc: stable@vger.kernel.org
Fixes: 0a3fe972a7cb ("HID: core: Mitigate potential OOB by removing bogus memset()")
Closes: https://lore.kernel.org/all/ahsh0UtTX6e0ZeHa@google.com/ [1]
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Lee Jones <lee@kernel.org>
Closes: https://lore.kernel.org/all/ahsh0UtTX6e0ZeHa@google.com/
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/uhid.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
index 09da654d2b05c..9121eed466858 100644
--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -597,8 +597,8 @@ static int uhid_dev_input(struct uhid_device *uhid, struct uhid_event *ev)
 	if (!READ_ONCE(uhid->running))
 		return -EINVAL;
 
-	hid_input_report(uhid->hid, HID_INPUT_REPORT, ev->u.input.data,
-			 min_t(size_t, ev->u.input.size, UHID_DATA_MAX), 0);
+	hid_safe_input_report(uhid->hid, HID_INPUT_REPORT, ev->u.input.data, UHID_DATA_MAX,
+			      min_t(size_t, ev->u.input.size, UHID_DATA_MAX), 0);
 
 	return 0;
 }
@@ -608,8 +608,8 @@ static int uhid_dev_input2(struct uhid_device *uhid, struct uhid_event *ev)
 	if (!READ_ONCE(uhid->running))
 		return -EINVAL;
 
-	hid_input_report(uhid->hid, HID_INPUT_REPORT, ev->u.input2.data,
-			 min_t(size_t, ev->u.input2.size, UHID_DATA_MAX), 0);
+	hid_safe_input_report(uhid->hid, HID_INPUT_REPORT, ev->u.input2.data, UHID_DATA_MAX,
+			      min_t(size_t, ev->u.input2.size, UHID_DATA_MAX), 0);
 
 	return 0;
 }
-- 
2.53.0




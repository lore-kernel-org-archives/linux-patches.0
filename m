Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057494;
	b=KbpS1tEzwWu2h1CFoCy4Ak7QXGeSFL7gQ/ukZJ2Yz1Y9zRD+TSOy1XnhC18cPsoSfwd/
	 /J6xojKMBn6vIhnLNoEOIy8yGveyO6/sw6m+tW6vpHME+BArhguJDv29JqEKZJSGg5YJc
	 jCqwl9e7ezPYPw7vkeVMlkf+Ry2ub3w6W2ndLCsACc+efqsCx/N7tfCPWPdq4apoFp4e+
	 IhpnpV7pH5RWozZlqlt0x0j8g6OGHWAy6Dx1zaGnC6xzsJFqZkElbPdzhLgPsHSt/8EA9
	 TB8k/cKSuyrJasb7p+PQFV6/mQU6oPGGGBXU1Ab2jRt1acWsw5A/eIIr20q+7L2nwRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057494;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GHoUV9lMSMzAepOHUjUGsOMlEileXAS+ycVszRO9Ipo=;
	b=keyPEBFQBkO6Xd6sSTYiGG9nbomj8uuWlQDSRjmGEk29TLtmRsLQnyQc+Ie68Tv0JBqh
	 FADMSj5p4bBmTdEUvo0fiA38r/QO+ocyabBpViSMDVY77iphR6tbDBZk9vHPpzkCMfh/X
	 cVkeLrOMbmErJFCMAki15pOmB968+odq52cxMtBoFMpakfFjQYfheEcTASFdrWVkDTGbE
	 mAcw6Wqwgh9CLIYoSBO1U9rgg6bw9a2iSG1fDUqJ8heYdr7lyotsZgT6WF9mf/mTZud1/
	 oaG+Gd8wkCaNGqY8jtKR7OE4pX9kivlDR7mzbhrdegpspYdgkZ+0akaoObT9PYYszAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="kNcJ+/Z6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78059606A338;
	Thu, 19 Nov 2026 03:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kNcJ+/Z6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06511F000C6;
	Thu, 19 Nov 2026 03:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057494;
	bh=GHoUV9lMSMzAepOHUjUGsOMlEileXAS+ycVszRO9Ipo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kNcJ+/Z63kdzeAXT5RWE4bZ0yR1ZbrnD7esxKq8JpQWrGjdqGF+sysGc9LYf8VRUC
	 4v4xw0JQGPaYspy+gCM+Q2CZbmCW7RQhAVraak2YBmSHoMqfCLWz/AtmJw/f7H2/aU
	 YSK+AojXlLmaSI4syV2UNGzbzVC8rW3SaF/S0Xyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0151/1848] HID: rmi: check report length before trimming sentinel bytes
Date: Wed, 18 Nov 2026 15:36:29 +0100
Message-ID: <20261118145917.557509615@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 28a3e326fad2451bdb66b747dd1f7ccbb900eed6 ]

rmi_check_sanity() trims trailing 0xff sentinel bytes, but its loop
reads data[valid_size - 1] before checking that valid_size is non-zero.

Reverse the condition so the length is proved before the last byte is
inspected.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-rmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
index a7d268ac45c49..e57b628db964e 100644
--- a/drivers/hid/hid-rmi.c
+++ b/drivers/hid/hid-rmi.c
@@ -386,7 +386,7 @@ static int rmi_check_sanity(struct hid_device *hdev, u8 *data, int size)
 	 * such reports here.
 	 */
 
-	while ((data[valid_size - 1] == 0xff) && valid_size > 0)
+	while (valid_size > 0 && data[valid_size - 1] == 0xff)
 		valid_size--;
 
 	return valid_size;
-- 
2.53.0




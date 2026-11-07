Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061793;
	b=Jyx+1QYCkAIrHzWy3ugbdLLcWZ984XNBlWND2mp6wre35Vxualq8GzcUBBS/sDEwFmWo
	 y5MCDe916FHRfPFi9HGG9To1yzpPKyVPwm3vDGdSHF20CPMfMzRzzgHIbyE2Cs4sDFv7g
	 EOliVu1keAUzFPxHLE2sFZ7osnP7Cl/QQ/dRhOtauXHwRUYKWwM4Q1Wv2Oj8uNchW2KtU
	 mv77UkWEN3qaHVEKEybh1z8ndMcHPaRguKea+of7Q+trWm4EDVfmib+7FZrk7VpB2jQav
	 LuzN9k5s6I6pyAod3QWTcQYExwLlWggeeZeKXO/CxczkU89b3yPNvpyNU5clvYbeGXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061793;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I1KIg26ko8xdCgqk/9lAT40cy0qDMGhMecSmQ9WcPHI=;
	b=UY0H6EwkT6G4uR1QVlXYJ39GBZJ5zT8P9p9Q3aedzePyZV0dKSHtu4SQ+ReW0B0EVSKK
	 rgLopdGWSw/nUbzAVfOFI8HXaTYUBYtsODPKUjUaIJ8k+rjXUjK4qYezaqAtGyw899LW0
	 if4P1JQmIv0ApBd1ZYZoR0zhEuCm/fS20hCQycrerKY81xFN0yXZphzXYK8qq2ykyNd27
	 QJkmgrACoCEHR5ACrWA5W4vVJiVqdg/nYYsmWZF8gCpdyvSPm0BDI9kzHpI4ZoeLraiPe
	 /U6ogsh7Krfq9QOgjaROTP4qj+szwhG4EgGGdrWCnUgBqOMD2wf+h6kV84/5lEIGE0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ceqcO1w5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49BA606A32F;
	Sat,  7 Nov 2026 14:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ceqcO1w5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED091F0089F;
	Sat,  7 Nov 2026 14:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061792;
	bh=I1KIg26ko8xdCgqk/9lAT40cy0qDMGhMecSmQ9WcPHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ceqcO1w5iRodht01cacBI7jDH4bNQgVFILnX/CPHd6W537Z53kcx4/pCeLtTAjC3n
	 KrCGxN9oHUlWsZxV5ljVIWs+52oM/gVdgnFwaEQLWqlcX0ZpMXpwRH12sKjPvbyHZw
	 3ajbkIls44nQO685F9iUrYZTHdwHIg4CuYj3/JHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.12 0821/1536] HID: roccat: koneplus: reject short button reports
Date: Sat,  7 Nov 2026 08:47:17 -0500
Message-ID: <20261107135020.603524196@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

commit d879e17a8b4c572c0b53b4e42a36849484e8f00c upstream.

The raw event callback runs before HID core validates and zero-pads the
report.  It passes the buffer to helpers which inspect data[0] and, for a
button report, read the complete struct koneplus_mouse_report_button.  A
truncated report can therefore cause an out-of-bounds read.

Require enough data for the button report before calling either helper.
Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw-event length validation to hid-asus.

Fixes: 47dbdbffe15b ("HID: roccat: Add support for Roccat Kone[+] v2")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-roccat-koneplus.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-roccat-koneplus.c
+++ b/drivers/hid/hid-roccat-koneplus.c
@@ -523,6 +523,9 @@ static int koneplus_raw_event(struct hid
 	if (koneplus == NULL)
 		return 0;
 
+	if (size < sizeof(struct koneplus_mouse_report_button))
+		return 0;
+
 	koneplus_keep_values_up_to_date(koneplus, data);
 
 	if (koneplus->roccat_claimed)



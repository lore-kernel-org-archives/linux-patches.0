Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9301E26CE32;
	Mon, 13 Apr 2026 16:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097293; cv=none; b=TpaSrB8bmIwR9xR2s01Pxa4//EICqyfUx1dhcq+Ix0c6tUqj1v1vGipvPO/6RjKVGBfdmUCC37iM+4SG64n5AZdm1h+Y0kgGZYy3K4EaZSUOJOOmaQWULmiqs/1qB3Z629RIynRm4l96FDnGD4YOtc1am5S2iSLFTwsHlNmjj74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097293; c=relaxed/simple;
	bh=TubOCuLEOP3BaYvS5v6m39ZpFpU93hgIABIbB9RMNfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gZaqmqwGS2oVC3hn3h15LypDCLv9iem4BFTyH5NiAJevHkRc3dcDZgQ7ixnkGFj4fMjMHhU6Bn4RA19d7X6KWfQNnGmV039+U8/7sBLgs0cTaSWOcHuQtzvqkJp2CqbAtN5qRjoUzdW3J4jVeQV41Xac1SivL5ibG/8wO5jIB3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZFt8tqL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZFt8tqL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29478C2BCAF;
	Mon, 13 Apr 2026 16:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097293;
	bh=TubOCuLEOP3BaYvS5v6m39ZpFpU93hgIABIbB9RMNfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZFt8tqLWAd3D7RXjZRVwOdMpjQQ2rmnyyYQpMh/0zwEGY0Omjs2Lq9aALiWR40U8
	 OSke6cBOi6FXB3sliaHwk/P3s+xnQ2dFDXoNZRMw0GS93VBHltbw2zysOziCQZRn/e
	 xchD//RyavWGDLClrquOZ49IJqT/ljM5tAa5YA08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olexa Bilaniuk <obilaniu@gmail.com>,
	Kurt Borja <kuurtb@gmail.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 5.15 053/570] platform/x86: dell-wmi: Add audio/mic mute key codes
Date: Mon, 13 Apr 2026 17:53:04 +0200
Message-ID: <20260413155832.428540487@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kurt Borja <kuurtb@gmail.com>

commit 26a7601471f62b95d56a81c3a8ccb551b5a6630f upstream.

Add audio/mic mute key codes found in Alienware m18 r1 AMD.

Cc: stable@vger.kernel.org
Tested-by: Olexa Bilaniuk <obilaniu@gmail.com>
Suggested-by: Olexa Bilaniuk <obilaniu@gmail.com>
Signed-off-by: Kurt Borja <kuurtb@gmail.com>
Acked-by: Pali Rohár <pali@kernel.org>
Link: https://patch.msgid.link/20260207-mute-keys-v2-1-c55e5471c9c1@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/dell/dell-wmi-base.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/platform/x86/dell/dell-wmi-base.c
+++ b/drivers/platform/x86/dell/dell-wmi-base.c
@@ -79,6 +79,12 @@ static const struct dmi_system_id dell_w
 static const struct key_entry dell_wmi_keymap_type_0000[] = {
 	{ KE_IGNORE, 0x003a, { KEY_CAPSLOCK } },
 
+	/* Audio mute toggle */
+	{ KE_KEY,    0x0109, { KEY_MUTE } },
+
+	/* Mic mute toggle */
+	{ KE_KEY,    0x0150, { KEY_MICMUTE } },
+
 	/* Meta key lock */
 	{ KE_IGNORE, 0xe000, { KEY_RIGHTMETA } },
 



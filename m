Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A9E17C9A9;
	Thu, 15 Aug 2024 13:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730225; cv=none; b=qN6Mtam3wJoQUfYZ26mrKjOx48vG7MZH3z+YaXpv/g0yz4qR1OgjLU4hPsVw3r51G3d0s9daXjHHI8X6P5n7hkZT8lG2/uEM6ps7y/6ECnwtWhc6qQmOWZBHLn/YkD0Pp0HtBSxodlPHZAnaOpWuZSLAyjQfsm4LZiRuwlq3138=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730225; c=relaxed/simple;
	bh=IvQ4+4PkgOnA/Hv1Il4MrJnBclbpOT4UcKi3PFrGO0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q1PyhE74X8ajY9IgA/TCYC/fZKrJRC5AJPXQOgCj/NrX6WrzwC34VZcC/lr4E54Zmdlk7rOi0qTx84+wR0+/2A3RNkjLXj1olt4+6RES92Msg2bx2EemKDtWhL8sjj5aRrQcjab0GS8M1LDRTmAVZJ7ZYpCzQQ/FgXyki8fgyz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2vp3EPbK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2vp3EPbK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0801C4AF0C;
	Thu, 15 Aug 2024 13:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730225;
	bh=IvQ4+4PkgOnA/Hv1Il4MrJnBclbpOT4UcKi3PFrGO0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2vp3EPbKGZbJlLzRwLD4gtxIFpe8WJAGTqk1EnOG44Hhg5ghlgPpl1fSAfdDX0Ade
	 9bvNWDob87wl36C34A3DqlutqLux4IX9vV8YomaJm78pa7/+XJiQvIbsirZZ0ifJpJ
	 5ZtVsVLRMFq7Ja1+EONG8sKrHDorrJv7W9XThSJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tatsunosuke Tobita <tatsunosuke.tobita@wacom.com>,
	Tatsunosuke Tobita <tatsunosuke.wacom@gmail.com>,
	Ping Cheng <ping.cheng@wacom.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	stable@kernel.org
Subject: [PATCH 5.15 343/484] HID: wacom: Modify pen IDs
Date: Thu, 15 Aug 2024 15:23:21 +0200
Message-ID: <20240815131954.668864263@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tatsunosuke Tobita <tatsunosuke.tobita@wacom.com>

commit f0d17d696dfce77c9abc830e4ac2d677890a2dad upstream.

The pen ID, 0x80842, was not the correct ID for wacom driver to
treat. The ID was corrected to 0x8842.
Also, 0x4200 was not the expected ID used on any Wacom device.
Therefore, 0x4200 was removed.

Signed-off-by: Tatsunosuke Tobita <tatsunosuke.tobita@wacom.com>
Signed-off-by: Tatsunosuke Tobita <tatsunosuke.wacom@gmail.com>
Fixes: bfdc750c4cb2 ("HID: wacom: add three styli to wacom_intuos_get_tool_type")
Cc: stable@kernel.org #6.2
Reviewed-by: Ping Cheng <ping.cheng@wacom.com>
Link: https://patch.msgid.link/20240709055729.17158-1-tatsunosuke.wacom@gmail.com
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_wac.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -714,13 +714,12 @@ static int wacom_intuos_get_tool_type(in
 	case 0x8e2: /* IntuosHT2 pen */
 	case 0x022:
 	case 0x200: /* Pro Pen 3 */
-	case 0x04200: /* Pro Pen 3 */
 	case 0x10842: /* MobileStudio Pro Pro Pen slim */
 	case 0x14802: /* Intuos4/5 13HD/24HD Classic Pen */
 	case 0x16802: /* Cintiq 13HD Pro Pen */
 	case 0x18802: /* DTH2242 Pen */
 	case 0x10802: /* Intuos4/5 13HD/24HD General Pen */
-	case 0x80842: /* Intuos Pro and Cintiq Pro 3D Pen */
+	case 0x8842: /* Intuos Pro and Cintiq Pro 3D Pen */
 		tool_type = BTN_TOOL_PEN;
 		break;
 



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4B035E4F2;
	Tue, 26 Aug 2025 14:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219474; cv=none; b=PJStfqYub7c+exC/NeR6MjqvQnO0tG1zY7TTZOcKgKRHNw8oYxQ+G1MpzIelbYGYA0M17P7WXxW/eeWWSZJKQ9uNIzhZnHgaN+r6eNXTSg/fNTsncX21eqW5fG+g6Eq4FTE4Dzbzb01VSvlUW+2AWf7QJJG4lze/dArkofTdDUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219474; c=relaxed/simple;
	bh=S0qJ+faNSVB4IkPsSZaf5JgLezN6fgcLU6gB/UegQTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eeQkOKEsanem5nod9EpwBCIkP7VR+WgHNqL+q9ijtjJPDBoKH+dDZpGUD7INLMfHaWvPnnN/qLLgN9LYyal004nn8fPyU9fJHZiWTXIsXeUj+5O+rleDun9GDytnkKFwRJD6y8m09cLuLITVapsOODbQY4pQ6vnR1eMcmummh5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KBfyPpy5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KBfyPpy5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37F6C116B1;
	Tue, 26 Aug 2025 14:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219474;
	bh=S0qJ+faNSVB4IkPsSZaf5JgLezN6fgcLU6gB/UegQTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KBfyPpy5t9zvm3FigHw4QaPmnMUYdCtMPfsxJDT+Sv/5Ug6AutHWZ6pUUQUixvQrT
	 7nb4n1TkfGb+Cju83Q0heLpLaK8YEkynnWd0Dtb25gYNWYMoEuCUXbK+zhd73xxo/J
	 o2wHKFvIfA2fzSwiGMPAWaMlL+FPbEUxDX1nmuFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 396/403] ALSA: usb-audio: Fix size validation in convert_chmap_v3()
Date: Tue, 26 Aug 2025 13:12:02 +0200
Message-ID: <20250826110917.974123678@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 89f0addeee3cb2dc49837599330ed9c4612f05b0 ]

The "p" pointer is void so sizeof(*p) is 1.  The intent was to check
sizeof(*cs_desc), which is 3, instead.

Fixes: ecfd41166b72 ("ALSA: usb-audio: Validate UAC3 cluster segment descriptors")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/aKL5kftC1qGt6lpv@stanley.mountain
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/stream.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/stream.c b/sound/usb/stream.c
index 47cfaf29fdd7..bb919f1d4043 100644
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -350,7 +350,7 @@ snd_pcm_chmap_elem *convert_chmap_v3(struct uac3_cluster_header_descriptor
 		u16 cs_len;
 		u8 cs_type;
 
-		if (len < sizeof(*p))
+		if (len < sizeof(*cs_desc))
 			break;
 		cs_len = le16_to_cpu(cs_desc->wLength);
 		if (len < cs_len)
-- 
2.50.1




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830867;
	b=IgnBPu7UKgjVQOJu7CQSeWRO25J6WUQNgzOK7pYensbDLUaqLszvoL2hGTTxoH4NJHzu
	 sn6dOuBoLDKvfZALBhKcEG4ErM1LPb5h7uBJ1EcT+ZwFB2i387e1/jE6g8JuWD533tC5p
	 sBLrAmRDIMJL9itWiIwMuBkXbHwzpuTp/b2A8voUa6JsuGw3liCcNguAjWpHP63T9OKVN
	 dzXRlCEws0I6p8V88EYZ2mLsEkFEhzGbYkubeb0rVkU+e0+UFGnAbkK9DpuDcXfehYhaK
	 UlFmuwC8vfAc13Ietcid5cEWjptEp92KGQmlvXrNaYPsyWTSVdD3JqgA1rcxKN7liUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830867;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JKowdcXLg8Fknoo5OSUzX3H7QeLBqyD9eASZcp7OhkE=;
	b=tHpUlII+WNRTwX3arHD06yc9waaEPZMj72tRQBYp9kHjTDsH5/8KBBkwJ9CeF+Kz7CKC
	 GomGeJtHtkzDciqB09Le19RDcNiiDp0FJpjgqnMHDnGVwY3sOV5hQtZmhylZ9TkkOkxN1
	 D23TTCoYT2t01kkD9f/YakIfLsnfiyQO/h5yUTj9RUW9xHxlxxEhdh5KtmP/AhxvX0aJ4
	 oG+oGoQHSjARb/h2hUXBcFYYj40XWA3QEJkolDLFbmVqvBcJup3KU/fcryLjthHF4HR6o
	 +lujlpmUfLfyHg61UPnCxiqWl41pwOy59hmaQ6s2bWZ2Y9NUeePeUivC/VnHpIRMDsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kuihESFt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67738606E80C;
	Wed,  4 Nov 2026 22:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kuihESFt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35C31F00A15;
	Wed,  4 Nov 2026 22:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830867;
	bh=JKowdcXLg8Fknoo5OSUzX3H7QeLBqyD9eASZcp7OhkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kuihESFt37/Ya5GTxKFdvwt1wGpyXEY9szaoUvBhNCX2FElFFpknWyAaSHDOaB4VV
	 6vIFJqGq7KyUwqEFE+rhn4jW3AHzKWbN74yLZfRbYmiAexFD0LytMW8qXCtvaPFOH7
	 B/5glnXckVm9fBXqoya6KFKYFreYDrRd5WOVxzwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0369/1005] fbdev: udlfb: validate vendor descriptor items
Date: Wed,  4 Nov 2026 16:01:42 -0500
Message-ID: <20261104211054.424069880@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 3cc2fad376ac7360b4518277aa923752624db59c ]

dlfb_parse_vendor_descriptor() walks key-length-value items inside the
DisplayLink vendor descriptor.

Require each item to contain its key, length and declared value bytes
before reading item-specific fields such as max_area.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/udlfb.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/video/fbdev/udlfb.c b/drivers/video/fbdev/udlfb.c
index 70ff38f35096a..1c82ee6984c8d 100644
--- a/drivers/video/fbdev/udlfb.c
+++ b/drivers/video/fbdev/udlfb.c
@@ -1586,19 +1586,29 @@ static int dlfb_parse_vendor_descriptor(struct dlfb_data *dlfb,
 		desc += 5; /* the fixed header we've already parsed */
 
 		while (desc < desc_end) {
+			char *value;
 			u8 length;
 			u16 key;
 
-			key = *desc++;
-			key |= (u16)*desc++ << 8;
+			if (desc_end - desc < sizeof(key) + sizeof(length))
+				goto unrecognized;
+
+			key = get_unaligned_le16(desc);
+			desc += sizeof(key);
 			length = *desc++;
 
+			if (length > desc_end - desc)
+				goto unrecognized;
+
+			value = desc;
 			switch (key) {
 			case 0x0200: { /* max_area */
-				u32 max_area = *desc++;
-				max_area |= (u32)*desc++ << 8;
-				max_area |= (u32)*desc++ << 16;
-				max_area |= (u32)*desc++ << 24;
+				u32 max_area;
+
+				if (length < sizeof(max_area))
+					goto unrecognized;
+
+				max_area = get_unaligned_le32(value);
 				dev_warn(&intf->dev,
 					 "DL chip limited to %d pixel modes\n",
 					 max_area);
-- 
2.53.0




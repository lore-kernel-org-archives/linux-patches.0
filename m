Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215824;
	b=xn9ILWI91S/QQFNTYuKOMyKccIBNvfkKCNPFj6cjqJr+AhqBbavTimZySoqMWqKGUxyb
	 w0Z3UE33IYSsEzc3qndsYY2tckkx7uJkK9Qcv9l2cNd23d7rE3LqXHxri3XDRLQu9AePX
	 mmwMurrs12an1RPWxlfc4xk0GQHr90PYDA3FkjGosOKWIpbLUb7MRAptrYtfzQQ4/CUM3
	 qtXavRFb3aozncHbUGjB/MzBhYxRAiGseoBjtvvE6wXWjLE4VAOc/z//5N/2+X7dEUPCR
	 gDbhuwlJJpAn/+RWTD8tOBNKONsIGK6x2HCVVkyn/lsfuYk5qpf5Iewv4WOXfTmGEhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215824;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YKxjxfz4lxa+Ay1uXqUSsgr4X7SoDObCZfnM42XijhU=;
	b=NEUL71yAgIs/mfYRtGLoDGmw+7CoxX1LwnCAJEXp6JRTBUXvnDBbg/PYkwFfuxePmbip
	 BJqhkyjH5AXowD5grhUAC+XteOlzqJmCM6MJTbEmZFgXt/LJu/eCblKhYuZh+vUGmRt4+
	 3ZpSeHEW39DGvUSVzJWENRJShYkgFYQW5VvCT4BTeuT9qvV4vC1+o3v8+USF2iZHmLgF5
	 Em9ybYebxysZZ+91bpHjQIKNK5LQj1zjNg/4hPypvlj22uQKDrU5KD7dixmhNvbKTfAmT
	 3th97hMFzsm1AvnH8o3/MxD1cvhimjx8a1SztMnx1iMBmG01GpslPnxlmLVD8n5kAsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="wOX/8PNu";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28265606A320;
	Wed, 28 Oct 2026 19:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wOX/8PNu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345841F01825;
	Wed, 28 Oct 2026 19:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215823;
	bh=YKxjxfz4lxa+Ay1uXqUSsgr4X7SoDObCZfnM42XijhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wOX/8PNubG46IxgOrn383ng5OKKGOjQM3Li1FkG0I+qPpi5YdTcFUCbYt9uaaXRMD
	 UI5s1s37oxgRJTx3Ep1h5rC7u+7OgtoXAq47vuoOpcyPtBlB61atTQcY9zhXMVKO42
	 WsPFpCGyZmKxl3pXO0Dju8J2KPX9kwGmLDhRXDMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Palacek <William.Palacek@amd.com>,
	Alysa Liu <Alysa.Liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1345/1887] drm/amdkfd: Add bounds check for CRAT subtype length
Date: Wed, 28 Oct 2026 17:57:21 +0100
Message-ID: <20261028170530.047155722@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Palacek <William.Palacek@amd.com>

[ Upstream commit 6e7566ba4739dd573c331adde1c96690f7a567bd ]

The CRAT parser validates that the subtype header fits within the image,
but does not verify that the advertised subtype length fits. A malformed
CRAT table with an oversized length field causes out-of-bounds reads when
kfd_parse_subtype() casts the header to specific subtype structures.

Add validation that sub_type_hdr + length does not exceed the image
boundary before parsing the subtype contents.

Signed-off-by: William Palacek <William.Palacek@amd.com>
Reviewed-by: Alysa Liu <Alysa.Liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 48e1d1e6e8798aef0312e68d8e586021b5b3cf4d)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
index 9c0ab7f41278c..78a5119c86eca 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
@@ -1324,6 +1324,15 @@ int kfd_parse_crat_table(void *crat_image, struct list_head *device_list,
 			break;
 		}
 
+		/* Validate subtype fits within remaining image */
+		if ((char *)sub_type_hdr + sub_type_hdr->length >
+		    (char *)crat_image + image_len) {
+			pr_warn("CRAT subtype length %u exceeds image bounds\n",
+				sub_type_hdr->length);
+			ret = -EINVAL;
+			break;
+		}
+
 		if (sub_type_hdr->flags & CRAT_SUBTYPE_FLAGS_ENABLED) {
 			ret = kfd_parse_subtype(sub_type_hdr, device_list);
 			if (ret)
-- 
2.53.0




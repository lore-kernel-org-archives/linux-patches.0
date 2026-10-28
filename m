Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215821;
	b=3K37M9ONCNQR1zEVEUvO6W4ToC5QJdSIGsxvwSGLCjMd9Ar9zMQ2tdPT/dsYZFgF0aue
	 Un/yGwfeMuq6uRQEEAMqkbfn+9nVkKtCGVj7gVAwtlntJB+IBhf7cT9Rw+G/d0dhE2N5e
	 R0MJMxur++zJ0hQj4pK0qASgB5HntYrwsUEpUuyIAJaHRAa5/TGsI+GAi7vznQ8no8MhA
	 HLyfPeWmNp0v5Yswt+mF/cqyqlKGOZflN0ujTe5e92pJHirV7vPXv9jbFYEy4GrECzqEF
	 YbWMIGXz1Qj/BQtKYbWkWVuUctsMpyx/AkHr8wd66/oOFFT0U6XbxhJ2kL9zkpDa3ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215821;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QZQlokM2JHRRzIdxIPSjAeTUlVbnXVCfLheJBPrCDc0=;
	b=H+LOdusA4UvpSLyn94JFA5paPwl9TB8h/95c6h+PyEL96H6rNSUbuMN1+a65p9tRdxWj
	 VpBLqPj9FXpYDkgiGWbRFB5EABh2yq49BeLDzL9s/L73pPVlhC7sMNuC2cTDL/+Y+cV3g
	 dunvp18nTSRlaYV/5eqwiUVzS8zzkiK/z8sX40eabTKjx4OUm2yKyIHTlcLEnuC+yxusr
	 4RXn7Yr9bSeRhtl/DaMOnoSFmxiFu09IzDwsSOR2VuWE9ijFOQZVdTWPFJvDnEiYCmFPR
	 hqLCPWWGUcqDWCYRCBp/wFOoEyO1QC+CaU+j5Lb/INTWDl9xnu5blxKkwyHwtHRb0vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="RQ5I/cGi";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F133D606A31A;
	Wed, 28 Oct 2026 19:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RQ5I/cGi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466B11F01825;
	Wed, 28 Oct 2026 19:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215820;
	bh=QZQlokM2JHRRzIdxIPSjAeTUlVbnXVCfLheJBPrCDc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RQ5I/cGiDP13GqUDLovyEa0l9I/dtCSHGHV8qWynvqUDSKsjjvsxQk0XgVFexAQp5
	 d2ERVcML419siz2uNl5cC5C5J3O7u4x7i7ie0IVgMtzuguFOjx/UqtQeyn8ps8mZ3N
	 8Xl2/ZdwJq8/dJM+mPoLgIR87BWFGudKt6JjHJoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongqiang Sun <Yongqiang.Sun@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1344/1887] drm/amdkfd: Fix infinite loop parsing CRAT with zero subtype length
Date: Wed, 28 Oct 2026 17:57:20 +0100
Message-ID: <20261028170530.025162141@linuxfoundation.org>
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

From: Yongqiang Sun <Yongqiang.Sun@amd.com>

[ Upstream commit 961323c26ad4c895e3b0ea1711fc41dfd6368c12 ]

Malformed ACPI CRAT tables can advertise a zero or undersized subtype
length. The parser then fails to advance the cursor and loops forever
while the remaining image still looks large enough for a generic header.

Validate sub_type_hdr->length on each iteration before parsing or
advancing. Return -EINVAL and warn when length is zero or smaller than
the generic subtype header.

Signed-off-by: Yongqiang Sun <Yongqiang.Sun@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 6e7566ba4739 ("drm/amdkfd: Add bounds check for CRAT subtype length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
index e45c6bc8d10bb..9c0ab7f41278c 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
@@ -1316,6 +1316,14 @@ int kfd_parse_crat_table(void *crat_image, struct list_head *device_list,
 	sub_type_hdr = (struct crat_subtype_generic *)(crat_table+1);
 	while ((char *)sub_type_hdr + sizeof(struct crat_subtype_generic) <
 			((char *)crat_image) + image_len) {
+		if (!sub_type_hdr->length ||
+		    sub_type_hdr->length < sizeof(struct crat_subtype_generic)) {
+			pr_warn("Invalid CRAT subtype length %u\n",
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




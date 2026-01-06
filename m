Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9EC35CB76;
	Tue,  6 Jan 2026 17:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721624; cv=none; b=aN1sGqUW/me1d1BBVaug5GvJkXsnWV9rv0aPGa0OJMCRhajsl424QcLZ8tYF6znFLJw+QzKD5lZTwAE6cG/KYNRBiYw3DmB1uxsYx1T8YxFNd673+LGPqPm0DgJ80z0WNEejIdbFQt242Mut0clB/jwulIsADvZfA8A12EyAvA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721624; c=relaxed/simple;
	bh=F+u1BFUCGAIR0ub/1v6ESNIlnbWImzI20qkk3xnW/bA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LKXtLTVrPHvTyG2pT471tkH+R4BcuccyPPqUhvYgvj9Au8MX4BGQz4krdi8Vk+x9PujZdzXd0r6HQAfcDDazu3hOkAb2hn+18lxdSTMveRpDLSB38r+++532OeLLgsRDB+wBhGOF1owrnpzZf9x49Ca56+adeLbbWa2RJOdHGns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WGhGvDy7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WGhGvDy7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6F1C2BC9E;
	Tue,  6 Jan 2026 17:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721624;
	bh=F+u1BFUCGAIR0ub/1v6ESNIlnbWImzI20qkk3xnW/bA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WGhGvDy7W7C0AD3lomer8N63HScFXyB4mc6Ff8eDYuIXGrwt2/vBcbRhU8J+qtJOs
	 BNRYtUwhgac1r3XAYR1B9XtChGGg2AeQN4D+zdt6q6kBlYXfe85aL5XgyGrQJGRG6o
	 QcutXPr1/cIcFsn8J2SlsswofZVAVrvHcY5pjKpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tiago=20Martins=20Ara=C3=BAjo?= <tiago.martins.araujo@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 009/312] drm/edid: add DRM_EDID_IDENT_INIT() to initialize struct drm_edid_ident
Date: Tue,  6 Jan 2026 18:01:23 +0100
Message-ID: <20260106170548.188919001@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 8b61583f993589a64c061aa91b44f5bd350d90a5 ]

Add a convenience helper for initializing struct drm_edid_ident.

Cc: Tiago Martins Araújo <tiago.martins.araujo@gmail.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Tested-by: Tiago Martins Araújo <tiago.martins.araujo@gmail.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/710b2ac6a211606ec1f90afa57b79e8c7375a27e.1761681968.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Stable-dep-of: 83cbb4d33dc2 ("drm/displayid: add quirk to ignore DisplayID checksum errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/drm/drm_edid.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/include/drm/drm_edid.h
+++ b/include/drm/drm_edid.h
@@ -340,6 +340,12 @@ struct drm_edid_ident {
 	const char *name;
 };
 
+#define DRM_EDID_IDENT_INIT(_vend_chr_0, _vend_chr_1, _vend_chr_2, _product_id, _name) \
+{ \
+	.panel_id = drm_edid_encode_panel_id(_vend_chr_0, _vend_chr_1, _vend_chr_2, _product_id), \
+	.name = _name, \
+}
+
 #define EDID_PRODUCT_ID(e) ((e)->prod_code[0] | ((e)->prod_code[1] << 8))
 
 /* Short Audio Descriptor */



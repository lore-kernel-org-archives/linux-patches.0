Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0297C217F24;
	Tue,  6 Jan 2026 17:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721304; cv=none; b=BWYGunLqNfWnh8HWeBYiCYhtM7uRmc29djgjLeuLHKXO2GlB5ZD5OvgkykKNB1cx8ef50ES1KoF73vzI7TJtkLCJ+EfH+Or2bwNSa8e0E6jyE5Pf6te5tRrsn+0h/GM3mZp3Tsqxt11/6preO6zzPGbALYWWc7P0Y4JxhITXJf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721304; c=relaxed/simple;
	bh=mf8U1NfBisDY4raQgpnP/E8LElzoC0dXHyWs47rONw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a4/ocVaxKZXgujkFNfgGfpVpNDvbjg0S7P/9pokaZzTAnBTKmmtaRLqZv8yMPEWKyuv/8hIgIXfQYVR/NwzEsK9r2TkhUJs2q4EIQTiMWJRw9iru1DSbxXNxTOXCzwsnKP99st/uWxRQtMqs6/VFYOk7OWYVicU+mAjmcK8lf3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=miBv3tzM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="miBv3tzM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 309DCC116C6;
	Tue,  6 Jan 2026 17:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721303;
	bh=mf8U1NfBisDY4raQgpnP/E8LElzoC0dXHyWs47rONw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=miBv3tzMU+pnwwd8N66/P7Z2TVj3yjnno6PriI15L3r6pNQF+F8ZLwzZ3FIBTcVLL
	 97VAVzfNUfOomykfO5UqahmRQuV+6/3m2EQgOyFfUprN1mxdw4x+Hebq+MFktdMjIB
	 S7paW1Ta2zmjez/ecmPkqPKapOnhIPN6mlVsrw5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tiago=20Martins=20Ara=C3=BAjo?= <tiago.martins.araujo@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.12 464/567] drm/edid: add DRM_EDID_IDENT_INIT() to initialize struct drm_edid_ident
Date: Tue,  6 Jan 2026 18:04:06 +0100
Message-ID: <20260106170508.513090527@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit 8b61583f993589a64c061aa91b44f5bd350d90a5 upstream.

Add a convenience helper for initializing struct drm_edid_ident.

Cc: Tiago Martins Araújo <tiago.martins.araujo@gmail.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Tested-by: Tiago Martins Araújo <tiago.martins.araujo@gmail.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/710b2ac6a211606ec1f90afa57b79e8c7375a27e.1761681968.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/drm/drm_edid.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/include/drm/drm_edid.h
+++ b/include/drm/drm_edid.h
@@ -333,6 +333,12 @@ struct drm_edid_ident {
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



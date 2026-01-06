Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4DD355042;
	Tue,  6 Jan 2026 17:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720295; cv=none; b=lcn0Kuod3U9OmKTvXXP6c0wqPt9oZ/HRtSuv3Cfgk3Cqf29ElBK8wuA0hTG40+HD995To2s6iG0+ROz7hIZAKiQADGpbWjNLmKlF1wOpzVXPXydH7KdWGmQ44CH39G3P+KJgOdV+fd8BR4HTWK93yT/aJcKIvN3w6oZSQ7tUQhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720295; c=relaxed/simple;
	bh=tNOUCJzX6HOKjCQifLvTqCZgvbtbyBTtdrEZT4t4+VQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lkt/I5LsyPuu79M+zhqmLb4D41Rx78Zxsl4EyxfjYqNL9GSCnuDpfKh2a7QH+6plOUr8gPojeAAvBw+JxB3gAVLBSAcGma17Ew524XttpEO02dHaNxkcuGPLysf9Pour5Rocgdp8Fa1r4tTzVOBi95aaPybZHU3vPjsHstDCUis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SdwPX+Yw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SdwPX+Yw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10661C116C6;
	Tue,  6 Jan 2026 17:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720295;
	bh=tNOUCJzX6HOKjCQifLvTqCZgvbtbyBTtdrEZT4t4+VQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SdwPX+YwQMylYPI0RDhvp8/dHYqFwONlM6bpvYkf55leuABiLWXZTmtW4G1iq+BCb
	 2wo7pTvrOFi8m/BUlP+E+c1LgkouB0HT60jpQcgYlgIcqHlOy6LF3n+RLX92e2lL5C
	 PuEuQQgm1xlg3YjCKk32qPyPTxlmJWJonTQODOAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Baoli Zhang <baoli.zhang@intel.com>,
	Junxiao Chang <junxiao.chang@intel.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [PATCH 6.12 193/567] mei: gsc: add dependency on Xe driver
Date: Tue,  6 Jan 2026 17:59:35 +0100
Message-ID: <20260106170458.465809445@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxiao Chang <junxiao.chang@intel.com>

commit 5d92c3b41f0bddfa416130c6e1b424414f3d2acf upstream.

INTEL_MEI_GSC depends on either i915 or Xe
and can be present when either of above is present.

Cc: stable <stable@kernel.org>
Fixes: 87a4c85d3a3e ("drm/xe/gsc: add gsc device support")
Tested-by: Baoli Zhang <baoli.zhang@intel.com>
Signed-off-by: Junxiao Chang <junxiao.chang@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Link: https://patch.msgid.link/20251109153533.3179787-1-alexander.usyskin@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/mei/Kconfig
+++ b/drivers/misc/mei/Kconfig
@@ -49,7 +49,7 @@ config INTEL_MEI_TXE
 config INTEL_MEI_GSC
 	tristate "Intel MEI GSC embedded device"
 	depends on INTEL_MEI_ME
-	depends on DRM_I915
+	depends on DRM_I915 || DRM_XE
 	help
 	  Intel auxiliary driver for GSC devices embedded in Intel graphics devices.
 



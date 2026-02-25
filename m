Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0FA1E2834;
	Wed, 25 Feb 2026 01:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983153; cv=none; b=n6OqOCq6YJqCVwZKa+/2tHd78U3rHcziWX+0Jg3UyUaG35sNQ8oC3SkqnkOf//RMOTkTDcZcs2jT4t04NU3qOLfJvsS0MIIW9rMQPgXTMzKBCdA/jZj8jP8jBrEN+JB2dFI/jJzY8q/lOa8SH7RVbnICKlDN45S8UIiJaKS+Ois=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983153; c=relaxed/simple;
	bh=TnoZ2E5e8WIOdl/w4U6Oq6n8+hPEIyOYM+aU1QGU+8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lYc5s1Z+P/80qKtabIp4PQjump66b2pGaMspHXnSgPPQJUPMsUgBgNTyZf8hePhWO/8fJV6zfFAr+HfV7AsOj9ZKs8xdK2SPT0S8ZH0cMsYJYUfzudiuc2AFPuL6pREWdqOKwAcKkj3lUFW1NfzjS5WJR2C9pgUqiLFeCXfRq0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x9tNPETa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x9tNPETa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69695C116D0;
	Wed, 25 Feb 2026 01:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983153;
	bh=TnoZ2E5e8WIOdl/w4U6Oq6n8+hPEIyOYM+aU1QGU+8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x9tNPETa/bZAOiryzAPOOL58BvOvhgTF0b1KJsB2+Sq8mMYN4PTDdQ+6E6gk+pPn2
	 qFyX5Q7NnsAufqCr86df8VktF+9mPxLDQQAcp4LUAm/RCMxkexff25NGpB0bsRqLYP
	 wlRAaaxUtE3LxbP6A3SrvIk0k6BoIelEmUGAgSC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Nitin Gote <nitin.r.gote@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 252/781] mei: late_bind: fix struct intel_lb_component_ops kernel-doc
Date: Tue, 24 Feb 2026 17:16:01 -0800
Message-ID: <20260225012405.889488839@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 936cae9254e55a39aeaa0c156a764d22f319338b ]

Fix kernel-doc warnings on struct intel_lb_component_ops:

Warning: include/drm/intel/intel_lb_mei_interface.h:55 Incorrect use of
  kernel-doc format: * push_payload - Sends a payload to the
  authentication firmware

And a bunch more. There isn't really support for documenting function
pointer struct members in kernel-doc, but at least reference the member
properly.

Fixes: 741eeabb7c78 ("mei: late_bind: add late binding component driver")
Cc: Alexander Usyskin <alexander.usyskin@intel.com>
Reviewed-by: Nitin Gote <nitin.r.gote@intel.com>
Link: https://patch.msgid.link/20260107160226.2381388-1-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/intel/intel_lb_mei_interface.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/drm/intel/intel_lb_mei_interface.h b/include/drm/intel/intel_lb_mei_interface.h
index d65be2cba2ab9..0850738a30fc7 100644
--- a/include/drm/intel/intel_lb_mei_interface.h
+++ b/include/drm/intel/intel_lb_mei_interface.h
@@ -53,7 +53,8 @@ enum intel_lb_status {
  */
 struct intel_lb_component_ops {
 	/**
-	 * push_payload - Sends a payload to the authentication firmware
+	 * @push_payload: Sends a payload to the authentication firmware
+	 *
 	 * @dev: Device struct corresponding to the mei device
 	 * @type: Payload type (see &enum intel_lb_type)
 	 * @flags: Payload flags bitmap (e.g. %INTEL_LB_FLAGS_IS_PERSISTENT)
-- 
2.51.0




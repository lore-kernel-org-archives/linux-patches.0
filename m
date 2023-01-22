Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD032590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:26:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DC1C433D2;
	Sun, 22 Jan 2023 15:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401177;
	bh=GV/0RIRLDbQ/69NyJGkV82zD13L1sZ5jj8r3Iflp25M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s+9+1fNpop0atdeXfFBcmDflpZyg3Sqj1CugFlds1SPjmpUAvTkI9f2uldV/0G078
	 yN00dg+LW8jpKdMpes3kcMvUsSXneDCMe3Nz1e9/amZiAbXx+6oGLfuEyf5F4Z2Ma6
	 8tv8C0yHPn7Qf7Uyw2uziaFRH9MO6qaa83N9Jyl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nirmoy Das <nirmoy.das@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.1 140/193] drm/i915: Remove unused variable
Date: Sun, 22 Jan 2023 16:04:29 +0100
Message-Id: <20230122150252.781318746@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nirmoy Das <nirmoy.das@intel.com>

commit 2293a73ad4f3b6c37c06713ff1b67659d92ef43d upstream.

Removed unused i915 var.

Fixes: a273e95721e9 ("drm/i915: Allow switching away via vga-switcheroo if uninitialized")
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230118170624.9326-1-nirmoy.das@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_driver.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/gpu/drm/i915/i915_driver.c
+++ b/drivers/gpu/drm/i915/i915_driver.c
@@ -1070,8 +1070,6 @@ static int i915_driver_open(struct drm_d
  */
 static void i915_driver_lastclose(struct drm_device *dev)
 {
-	struct drm_i915_private *i915 = to_i915(dev);
-
 	intel_fbdev_restore_mode(dev);
 
 	vga_switcheroo_process_delayed_switch();



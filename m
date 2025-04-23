Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310E057C9F;
	Wed, 23 Apr 2025 15:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421241; cv=none; b=XJbKW1qjAqV6echHRi6/Eu88rc0YWl3FAjnUTpPwTgv8rVD9Ju+vej8t3q43Og19kY/IE3Z8fPPMDBXLhLEEDcrD07JS1mxfdM0tSqaoM2d9fXZ9SOT8xVzvqsHuCCyn90bpT/gGSWkwVGwcezIj/BE+V8eTAzPDWeVTrIV+eV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421241; c=relaxed/simple;
	bh=YF8TeajqCQP5U28EZzKjHRvrUAm8BBGP6q3PJ/uc35Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DO79YlVl2VO/b8OMQ1LK3slO4JmjGYCN3Gr/IktZo5qBnTt81HduRCmZSm/WuazlJAvxXzMQNasKD2AAxG5AWJuy7uaezQaubMu5FI0WIutXItwWuOgsGS+0q08M1N2p7Yi8uMzW2uzIRK5AlBYCdwHk2AgZ9emhAfPR8wZ3hjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MQxGEWaP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MQxGEWaP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4DBBC4CEE2;
	Wed, 23 Apr 2025 15:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421241;
	bh=YF8TeajqCQP5U28EZzKjHRvrUAm8BBGP6q3PJ/uc35Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MQxGEWaPDen0JFdRyyRRV8f1kNq/lhvytkn3tCPIfqYYWlyXzZhUrSslXZ35lkIMe
	 dMhkhCkcmLM67cgG2sTPw5k0UanZeQ1NjhTzPHieYYy+PBv+zIIX7XyjuNzfcVe9nI
	 Yv+iYEuUNUepjtyazKSj8ftXP++Ngaqzo0zdOMok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sun peng Li <sunpeng.li@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 204/223] drm/amd/display: Temporarily disable hostvm on DCN31
Date: Wed, 23 Apr 2025 16:44:36 +0200
Message-ID: <20250423142625.477282455@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

commit ba93dddfc92084a1e28ea447ec4f8315f3d8d3fd upstream.

With HostVM enabled, DCN31 fails to pass validation for 3x4k60. Some Linux
userspace does not downgrade one of the monitors to 4k30, and the result
is that the monitor does not light up. Disable it until the bandwidth
calculation failure is resolved.

Reviewed-by: Sun peng Li <sunpeng.li@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/resource/dcn31/dcn31_resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/resource/dcn31/dcn31_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn31/dcn31_resource.c
@@ -891,7 +891,7 @@ static const struct dc_debug_options deb
 	.disable_z10 = true,
 	.enable_legacy_fast_update = true,
 	.enable_z9_disable_interface = true, /* Allow support for the PMFW interface for disable Z9*/
-	.dml_hostvm_override = DML_HOSTVM_NO_OVERRIDE,
+	.dml_hostvm_override = DML_HOSTVM_OVERRIDE_FALSE,
 	.using_dml2 = false,
 };
 



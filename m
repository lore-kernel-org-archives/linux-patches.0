Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257F04315A;
	Sun,  7 Sep 2025 20:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277797; cv=none; b=I4lvikTxvHx6LpgIiEe97cv26UN2Wj7SSbI9gJm4WsZiJ3MkkT/enlMRbD54G21v6W5ncWY4MsMuRKVqGALk0ntkR3DRqz/U4jo4onyG1qn+JVfo74/A6Hy3wjPZBpIQ2BgR5qc2HhgFgtcmi4tR/1G9E+Wz2quIcjJ77Rpryvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277797; c=relaxed/simple;
	bh=/LaBln+rZmxa2XQ3BPLHzBtB13i/OQu0Doh0WsWMKEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lfi6cf0L0Dkp3i3jDHbhaYAMmhSBum5r/hEE/1dcYW6UdUvHt6LvOZiPPoOIXr7xYyAxpHmatBXiE+/+K0FO0+uzipNeCF3ya61YbZle5N+jFE2TMBP9bhVWkgQJdqfHalBHIctuPJvNQ3lZPrSuEsDmRF0VuZHgTj+rOgYMasA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q/CHLQqw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q/CHLQqw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A107C4CEF0;
	Sun,  7 Sep 2025 20:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277797;
	bh=/LaBln+rZmxa2XQ3BPLHzBtB13i/OQu0Doh0WsWMKEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q/CHLQqw0oVw/+lYGgm9gM7dd6/z1oCLOPDZwLajJRxEqdGIoWdv+MIx9+PTv4K8y
	 rQPowOLtym/Xrj3H84HtW46bTY4FSZAWbENBeM5G2Hr/V+jXaxgRNkAz8s6rB4tsxg
	 3LY4xB6HNGJ2bfwduhGVcPpjB2QYzJg2ardBd/6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	shaoyun.Liu@amd.com,
	"Shaoyun.liu" <Shaoyun.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.16 127/183] drm/amdgpu/mes11: make MES_MISC_OP_CHANGE_CONFIG failure non-fatal
Date: Sun,  7 Sep 2025 21:59:14 +0200
Message-ID: <20250907195618.810276823@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 5171848bdfb8bf87f38331d3f8c0fd5e2b676d3e upstream.

If the firmware is too old, just warn and return success.

Fixes: 27b791514789 ("drm/amdgpu/mes: keep enforce isolation up to date")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4414
Cc: shaoyun.Liu@amd.com
Reviewed-by: Shaoyun.liu <Shaoyun.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 9f28af76fab0948b59673f69c10aeec47de11c60)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
@@ -641,8 +641,9 @@ static int mes_v11_0_misc_op(struct amdg
 		break;
 	case MES_MISC_OP_CHANGE_CONFIG:
 		if ((mes->adev->mes.sched_version & AMDGPU_MES_VERSION_MASK) < 0x63) {
-			dev_err(mes->adev->dev, "MES FW version must be larger than 0x63 to support limit single process feature.\n");
-			return -EINVAL;
+			dev_warn_once(mes->adev->dev,
+				      "MES FW version must be larger than 0x63 to support limit single process feature.\n");
+			return 0;
 		}
 		misc_pkt.opcode = MESAPI_MISC__CHANGE_CONFIG;
 		misc_pkt.change_config.opcode =



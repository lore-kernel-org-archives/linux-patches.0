Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9F72571AB;
	Tue, 25 Mar 2025 12:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906033; cv=none; b=l4cBFJz0SV9Vd+YpSr7L6L2Y63w9wShd0Mwnp3o4ERNqWyCepmVtvMdWDpAdGmJr6cracDtipuccQoPC/w6CaHR6f4XsJgNLs55nKq07iggiQx9HoK7ESIF7uZD1UA5QkY13uvfu+VtyadNXV4lNdE/JH+kcNzxATccWHGScGBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906033; c=relaxed/simple;
	bh=jDo9v4Dx7iVJRNltJ6YgNUHi4Dg6hfVrbSZTDrI0P5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pIasNkQjHe2s7YMAldXWLGuehsiuTsvUSaJkWBHtA5GetshvyvNB+/IHXvU1fM2m42rOFlKcDWLqh+acaxwMR29K4/hCJFkW3VvmZruXspNRBeb3SUeXfmP3lrthTKkNrC6RX6TuBSvKqq+tkHUv994iSCWB38IsDzJwZbtoEnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BlLDT7pd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BlLDT7pd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C753C4CEE4;
	Tue, 25 Mar 2025 12:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906033;
	bh=jDo9v4Dx7iVJRNltJ6YgNUHi4Dg6hfVrbSZTDrI0P5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BlLDT7pd73j55fZuA3Q33RpI4+Qx8gc1CoYGiml3sml6jQFecgT3V/iQuVIPtAH/5
	 Aacgq1rQTnrbGywVvKtP3nnJM1xY3lWs+60X4UntCxY9m/o6vZHY+McgtfYrTGuVm4
	 dh1R7Ca/qGdn/F9VmfKKHTvG7yxoUIOHg3/HfkKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.13 099/119] drm/amd/pm: add unique_id for gfx12
Date: Tue, 25 Mar 2025 08:22:37 -0400
Message-ID: <20250325122151.588480935@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>

commit 19b53f96856b5316ee1fd6ca485af0889e001677 upstream.

Expose unique_id for gfx12

Signed-off-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 16fbc18cb07470cd33fb5f37ad181b51583e6dc0)
Cc: stable@vger.kernel.org # 6.12.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_pm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -2421,6 +2421,8 @@ static int default_attr_update(struct am
 		case IP_VERSION(11, 0, 1):
 		case IP_VERSION(11, 0, 2):
 		case IP_VERSION(11, 0, 3):
+		case IP_VERSION(12, 0, 0):
+		case IP_VERSION(12, 0, 1):
 			*states = ATTR_STATE_SUPPORTED;
 			break;
 		default:



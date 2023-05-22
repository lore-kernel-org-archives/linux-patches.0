Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BDFF171B8
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:53:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73A8C4339B;
	Mon, 22 May 2023 19:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684785192;
	bh=ot84JLftX/MyUOeon+g4lcPXlfsk36amFyeoRnplP0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=isdegWEArCrh0044eM4VlAdMplYquxOnJcoWBHa2M7h+k3jxf/MsTvFVQ0uB7qp+Z
	 +sLxbCRPZObPH1MDcmv+FUrzw85iaNrIXtaxAEZ4BRGdYlu7+k2zABRQWK1tjqm4bS
	 lHpmz9oAoxEJFgFVPK45NMFCv0eVrHMj4BE8M1jQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.3 340/364] drm/amdgpu/gfx11: Adjust gfxoff before powergating on gfx11 as well
Date: Mon, 22 May 2023 20:10:45 +0100
Message-Id: <20230522190421.270621172@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guilherme G. Piccoli <gpiccoli@igalia.com>

commit 11fbdda2ab6bf049e2869139c07016022b4e045b upstream.

(Bas: speculative change to mirror gfx10/gfx9)

Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -5135,8 +5135,14 @@ static int gfx_v11_0_set_powergating_sta
 		break;
 	case IP_VERSION(11, 0, 1):
 	case IP_VERSION(11, 0, 4):
+		if (!enable)
+			amdgpu_gfx_off_ctrl(adev, false);
+
 		gfx_v11_cntl_pg(adev, enable);
-		amdgpu_gfx_off_ctrl(adev, enable);
+
+		if (enable)
+			amdgpu_gfx_off_ctrl(adev, true);
+
 		break;
 	default:
 		break;



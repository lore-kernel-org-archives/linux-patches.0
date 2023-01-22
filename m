Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CA22590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:27:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 156A0C433D2;
	Sun, 22 Jan 2023 15:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401256;
	bh=eh9dQx2MdJXKK+RotbNGFFipuOfEOyKfPsykHKGVShE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SgfQqoPXb+TrysqKuElyq71gspRCcbqVp6dtBYRDcfnvMfc3mG4m5jNj/jKkwsza2
	 5gXwNCRZO9yD0JeItf2X8GbKzF2wlb/jKjYaZiHn3oxQO55P3U+J74V59DL/tKkLSa
	 umvcliGbN0lhnD3SsxSUGRY/WkUZ5QGsaFuQ9mdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Aaron Liu <aaron.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 6.1 170/193] drm/amdgpu/pm: enable swsmu for SMU IP v13.0.11
Date: Sun, 22 Jan 2023 16:04:59 +0100
Message-Id: <20230122150254.182304700@linuxfoundation.org>
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

From: Yifan Zhang <yifan1.zhang@amd.com>

commit 16412a94364d1dcebded9217ecb693c9659eaabc upstream.

Add the entry to set the ppt functions for SMU IP v13.0.11.

Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: Aaron Liu <aaron.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -585,6 +585,7 @@ static int smu_set_funcs(struct amdgpu_d
 		yellow_carp_set_ppt_funcs(smu);
 		break;
 	case IP_VERSION(13, 0, 4):
+	case IP_VERSION(13, 0, 11):
 		smu_v13_0_4_set_ppt_funcs(smu);
 		break;
 	case IP_VERSION(13, 0, 5):



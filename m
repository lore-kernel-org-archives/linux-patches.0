Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8551157E62;
	Mon, 29 Jan 2024 17:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548250; cv=none; b=OolVFB2A2SMgFXnfsIvefiipqcX8uinr2R7ThN/jcIn3UEQqyxfw2aoHSZ3ayHtbl19UdpbEfDtZ7NM/1InQo4nHu5qLitL5iNXIpQk8uRnLINuCXGoCCl34KCuv2HP62kYfkXroMGXgh1LimVpQJOX7RpaXApqQuG9rM4eBR+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548250; c=relaxed/simple;
	bh=MFp0ZCzRFRONJ3DHJwaO4gcb9049vS3UprduSHUxY3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j9ZvaMSBVts0J+9s67KU7W3+vgPv3oVgc5cPBvphwn8iGbVLKZtEljcUaF+TC9WtutGisPTNMDH5IUw+pbZzifMDkVIlpCUToCObm2Z+0WsdwTVlEKOY3d6kNgUouRs/WSX+k2tdbxSh0tbhAa7sMDE2qMu5eyNWetL2t8LORlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oKd0t8xT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oKd0t8xT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F83DC433C7;
	Mon, 29 Jan 2024 17:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548249;
	bh=MFp0ZCzRFRONJ3DHJwaO4gcb9049vS3UprduSHUxY3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oKd0t8xTc4RjW9d5fAlud9uu3kM/so//bHPTTbsFIlzJI3ioQVHqRorNtlznSOrgM
	 aJYp7mkXyCZpGB7BP/K8ehRYCyy2kDOE+CxEji+Tsj5v9TGxRkRkiM3VchdwTF2+Fq
	 qKTVyfPtFeBBqWDQd5xOfnZOMX9fxokenFIx9qJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.7 272/346] drm/amd/display: Fix a switch statement in populate_dml_output_cfg_from_stream_state()
Date: Mon, 29 Jan 2024 09:05:03 -0800
Message-ID: <20240129170024.381718768@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 05638ff6dd6f0f38734b6b3ee2c7cf15520f5c00 upstream.

It is likely that the statement related to 'dml_edp' is misplaced. So move
it in the correct "case SIGNAL_TYPE_EDP".

Fixes: 7966f319c66d ("drm/amd/display: Introduce DML2")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml2_translation_helper.c
@@ -624,8 +624,8 @@ static void populate_dml_output_cfg_from
 		if (is_dp2p0_output_encoder(pipe))
 			out->OutputEncoder[location] = dml_dp2p0;
 		break;
-		out->OutputEncoder[location] = dml_edp;
 	case SIGNAL_TYPE_EDP:
+		out->OutputEncoder[location] = dml_edp;
 		break;
 	case SIGNAL_TYPE_HDMI_TYPE_A:
 	case SIGNAL_TYPE_DVI_SINGLE_LINK:



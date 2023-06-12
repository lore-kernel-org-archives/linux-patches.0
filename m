Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88526ECC
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:35:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 122FEC433D2;
	Mon, 12 Jun 2023 10:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566124;
	bh=f6j0ipduZOltD2lF866egq2uGyUw77pk2a78z2q0RJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rYAkcDXdlQF37E9uqYMJdFwB2Ph9Ov4/Qhn0NWibTBzz0TsPwYr4FvVo4WPBD+6P2
	 XZh1rqQZlJXaCy3+ifRlNAysCneDFLvnjG/DZEFE3I7WFo9GLsxjRnSAeTWa8rDiGL
	 la3cyAUffrX1p5S/t8E6JfY3/G40kBJK2/1jeIBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev
Subject: [PATCH 5.10 54/68] staging: vc04_services: fix gcc-13 build warning
Date: Mon, 12 Jun 2023 12:26:46 +0200
Message-ID: <20230612101700.683546926@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101658.437327280@linuxfoundation.org>
References: <20230612101658.437327280@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Not upstream as newer kernels fixed this properly.

Fix up a mismatched function prototype warning in the vc04_services
driver that gcc-13 shows.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -2315,7 +2315,7 @@ vchiq_arm_init_state(struct vchiq_state
 	return VCHIQ_SUCCESS;
 }
 
-enum vchiq_status
+int
 vchiq_use_internal(struct vchiq_state *state, struct vchiq_service *service,
 		   enum USE_TYPE_E use_type)
 {
@@ -2375,7 +2375,7 @@ out:
 	return ret;
 }
 
-enum vchiq_status
+int
 vchiq_release_internal(struct vchiq_state *state, struct vchiq_service *service)
 {
 	struct vchiq_arm_state *arm_state = vchiq_platform_get_arm_state(state);



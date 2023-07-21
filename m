Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE0A1EA8A
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:21:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFB02C43397;
	Fri, 21 Jul 2023 16:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956463;
	bh=tgFzvKUHYoeAKS0GWZZZ+yXSaLZV1Ogk6qV2XcgO2DU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s1PbsFtH4AEoQFyG1MKx3Uf/GVfbFxCkSyuzdZHP2RXXgnJAFPXgZXYQzMp4RU35r
	 4WicLRnpJzQoma9x9SEm5fQZ9gtjegOxX12C+v1a5wkN4IoKnw8sGSGai0132PVOHf
	 LLbxjXH+E0FYC3AAYrMTXFpDz5QjYEDdWE7MeyUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Leo Chen <sancchen@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.4 202/292] drm/amd/display: disable seamless boot if force_odm_combine is enabled
Date: Fri, 21 Jul 2023 18:05:11 +0200
Message-ID: <20230721160537.560584988@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Leo Chen <sancchen@amd.com>

commit 26518b39181876064850209ecdab48c0ee5924b1 upstream.

[Why & How]
Having seamless boot on while forcing debug option ODM combine 2 to 1
will cause some corruptions because of some missing programmings.

Cc: stable@vger.kernel.org # 6.1+
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Leo Chen <sancchen@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1602,6 +1602,9 @@ bool dc_validate_boot_timing(const struc
 		return false;
 	}
 
+	if (dc->debug.force_odm_combine)
+		return false;
+
 	/* Check for enabled DIG to identify enabled display */
 	if (!link->link_enc->funcs->is_dig_enabled(link->link_enc))
 		return false;



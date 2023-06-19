Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AAEC123
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 11:01:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B88C433C8;
	Mon, 19 Jun 2023 11:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172486;
	bh=xTTRDidfmK57WDOK+smNfRhQQd3ht4ttZwR0D/Gt3n8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lUBhHwWTPk/3M8M2ijtM3q7X6XR1Eyta9n19LbX0cDwZVj83KzkUCNZ/M5wheskZV
	 QUfutiAzN6gpW8XYbO/B/5tKEhDPlxSxJQN2PyNhq1e6eVt5r5H8/uAuXEM/yYRrQA
	 KAq70E+4zcoaLuSaBuO51qgDyYM+6RL46Z/xYyu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	michel@daenzer.net,
	=?UTF-8?q?Michel=20D=C3=A4nzer?= <mdaenzer@redhat.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 050/107] drm/amdgpu: add missing radeon secondary PCI ID
Date: Mon, 19 Jun 2023 12:30:34 +0200
Message-ID: <20230619102143.896311405@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102141.541044823@linuxfoundation.org>
References: <20230619102141.541044823@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alex Deucher <alexander.deucher@amd.com>

commit e61f67749b351c19455ce3085af2ae9af80023bc upstream.

0x5b70 is a missing RV370 secondary id.  Add it so
we don't try and probe it with amdgpu.

Cc: michel@daenzer.net
Reviewed-by: Michel Dänzer <mdaenzer@redhat.com>
Tested-by: Michel Dänzer <mdaenzer@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1557,6 +1557,7 @@ static const u16 amdgpu_unsupported_pcii
 	0x5874,
 	0x5940,
 	0x5941,
+	0x5b70,
 	0x5b72,
 	0x5b73,
 	0x5b74,



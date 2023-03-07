Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843A7BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:15:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7736C433EF;
	Tue,  7 Mar 2023 17:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209337;
	bh=0Ygr5Q+4JTuHWytzLIR9ppCJ9rwgirIIcE9/ohIHY/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GyjaXFMIsbMNte75KAHzkZgmVrIugN6To60S6F+PL4r9/DZyf74PcVB0r9vG7EYvB
	 QnPkvwYIa2tWZ9J6ibOmmpeTMlTSiKlaQPsVHzS1LHyIsu9VeBeKIgqfqhW/KeAEar
	 jFMYVoktwWESuM5vnUendWs5DX2tQV8g6sB1qjY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ludovic LHours <ludovic.lhours@gmail.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0185/1001] libbpf: Fix map creation flags sanitization
Date: Tue,  7 Mar 2023 17:49:17 +0100
Message-Id: <20230307170029.925699892@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ludovic L'Hours <ludovic.lhours@gmail.com>

[ Upstream commit 6920b08661e3ad829206078b5c9879b24aea8dfc ]

As BPF_F_MMAPABLE flag is now conditionnaly set (by map_is_mmapable),
it should not be toggled but disabled if not supported by kernel.

Fixes: 4fcac46c7e10 ("libbpf: only add BPF_F_MMAPABLE flag for data maps with global vars")
Signed-off-by: Ludovic L'Hours <ludovic.lhours@gmail.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20230108182018.24433-1-ludovic.lhours@gmail.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 2a82f49ce16f3..adf818da35dda 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -7355,7 +7355,7 @@ static int bpf_object__sanitize_maps(struct bpf_object *obj)
 		if (!bpf_map__is_internal(m))
 			continue;
 		if (!kernel_supports(obj, FEAT_ARRAY_MMAP))
-			m->def.map_flags ^= BPF_F_MMAPABLE;
+			m->def.map_flags &= ~BPF_F_MMAPABLE;
 	}
 
 	return 0;
-- 
2.39.2




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904947C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:25:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13EC8C433EF;
	Mon, 24 Apr 2023 13:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342722;
	bh=T7sPgeZWaMHUXeeot7fb5Pe61axswwSYZIpjGPzNdjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a3e2PReRLFOFRt3IlqwXOCVhKwS6Y6KTejjNuDtpKepLW/hi5TfjrVdohLi17AGSN
	 IFRBUu37MKp2FTBbBRCdzqBrtcc3B5ZCr0xdv9MuA6ZAMkMX4PIvPsQBezq3aDr5ss
	 +7ofgKlQMu0eep7Arcs5jGQ9PTiLk2vZFJQbcPM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Raillard <douglas.raillard@arm.com>,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 33/98] f2fs: Fix f2fs_truncate_partial_nodes ftrace event
Date: Mon, 24 Apr 2023 15:16:56 +0200
Message-Id: <20230424131135.180709225@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Douglas Raillard <douglas.raillard@arm.com>

[ Upstream commit 0b04d4c0542e8573a837b1d81b94209e48723b25 ]

Fix the nid_t field so that its size is correctly reported in the text
format embedded in trace.dat files. As it stands, it is reported as
being of size 4:

        field:nid_t nid[3];     offset:24;      size:4; signed:0;

Instead of 12:

        field:nid_t nid[3];     offset:24;      size:12;        signed:0;

This also fixes the reported offset of subsequent fields so that they
match with the actual struct layout.

Signed-off-by: Douglas Raillard <douglas.raillard@arm.com>
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/f2fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index e57f867191ef1..eb53e96b7a29c 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -505,7 +505,7 @@ TRACE_EVENT(f2fs_truncate_partial_nodes,
 	TP_STRUCT__entry(
 		__field(dev_t,	dev)
 		__field(ino_t,	ino)
-		__field(nid_t,	nid[3])
+		__array(nid_t,	nid, 3)
 		__field(int,	depth)
 		__field(int,	err)
 	),
-- 
2.39.2




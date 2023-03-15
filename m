Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E974431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1183DC433D2;
	Wed, 15 Mar 2023 12:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678882556;
	bh=othGfl9WeYZBaUSTdRDj1qsQ3+nTqmOWnOWtidNc+vM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e7UVl3rZlL4C4jfdCQ1w1+nw1Xpe+nFMo3WVFvcrkGznlVHuIROwqjfHb/9z2FknB
	 X1pbAgyLJ0EL9ZghXSRvSyJdsTn2hqQXS29lynDqFxa9VHiWx3dC4m15gMmC/QOkn3
	 IMVCYzPtZ4IxRLsZgq8+noxvulitq2YWHKICN2SM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 09/39] udf: Explain handling of load_nls() failure
Date: Wed, 15 Mar 2023 13:12:23 +0100
Message-Id: <20230315115721.595124167@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115721.234756306@linuxfoundation.org>
References: <20230315115721.234756306@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jan Kara <jack@suse.cz>

[ Upstream commit a768a9abc625d554f7b6428517089c193fcb5962 ]

Add comment explaining that load_nls() failure gets handled back in
udf_fill_super() to avoid false impression that it is unhandled.

Signed-off-by: Jan Kara <jack@suse.cz>
Stable-dep-of: fc8033a34a3c ("udf: Preserve link count of system files")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/super.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index b7fb7cd35d89a..5d179616578cf 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -572,6 +572,11 @@ static int udf_parse_options(char *options, struct udf_options *uopt,
 			if (!remount) {
 				if (uopt->nls_map)
 					unload_nls(uopt->nls_map);
+				/*
+				 * load_nls() failure is handled later in
+				 * udf_fill_super() after all options are
+				 * parsed.
+				 */
 				uopt->nls_map = load_nls(args[0].from);
 				uopt->flags |= (1 << UDF_FLAG_NLS_MAP);
 			}
-- 
2.39.2




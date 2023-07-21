Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0A827F3E
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:12:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2044C433C7;
	Fri, 21 Jul 2023 19:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966773;
	bh=HdprXXbPEgmmaFetJ5jxyRZJ2Coz7MOF3Xtvzjvzcjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0OJfyRC4a6Y6FbFqBQ+KPQjdl1tQo5Kt6yXXSMVD0I7XaJCdqVBme8eR0hDnSVqkS
	 5X8PWlFrY8gwss9aXCIpjbucHmtxNfbzQnS+YJE7bmPEdbRD2fV0j4p0i6xwERgAJz
	 2fJAYrU3uWqcIDJuVx00zNmq51dm97kskPa3OuVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	stable@kernel.org,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 462/532] ext4: fix wrong unit use in ext4_mb_clear_bb
Date: Fri, 21 Jul 2023 18:06:06 +0200
Message-ID: <20230721160639.588439400@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kemeng Shi <shikemeng@huaweicloud.com>

commit 247c3d214c23dfeeeb892e91a82ac1188bdaec9f upstream.

Function ext4_issue_discard need count in cluster. Pass count_clusters
instead of count to fix the mismatch.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: stable@kernel.org
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://lore.kernel.org/r/20230603150327.3596033-11-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -6086,8 +6086,8 @@ do_more:
 		 * them with group lock_held
 		 */
 		if (test_opt(sb, DISCARD)) {
-			err = ext4_issue_discard(sb, block_group, bit, count,
-						 NULL);
+			err = ext4_issue_discard(sb, block_group, bit,
+						 count_clusters, NULL);
 			if (err && err != -EOPNOTSUPP)
 				ext4_msg(sb, KERN_WARNING, "discard request in"
 					 " group:%u block:%d count:%lu failed"



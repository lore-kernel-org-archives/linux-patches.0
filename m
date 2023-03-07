Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346CCBA4F
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:04:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E153C433EF;
	Tue,  7 Mar 2023 19:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215863;
	bh=GD9fZiPmg8hvZaGBCbqBinxIG6NERqz58DxiMg3ekjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gTHZFrqNyL/tQ5jHCyw9n8bPe6NAlS4EwQWEuds+vQR2/PTRVinVpCF9rQsP7gtbK
	 87bjSlSuavVjh3aSUd7dHqNnll8rgDO+1RnpQkFZPCXr1DdCWU9haGXjig6xa3TeUc
	 ArQKMzuBg9pLdRnLCD4fFOqtyKErVJWZsLt3j1/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 365/567] udf: Define EFSCORRUPTED error code
Date: Tue,  7 Mar 2023 18:01:41 +0100
Message-Id: <20230307165921.673857924@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

[ Upstream commit 3d2d7e61553dbcc8ba45201d8ae4f383742c8202 ]

Similarly to other filesystems define EFSCORRUPTED error code for
reporting internal filesystem corruption.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/udf_sb.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index 4fa620543d302..2205859731dc2 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -51,6 +51,8 @@
 #define MF_DUPLICATE_MD		0x01
 #define MF_MIRROR_FE_LOADED	0x02
 
+#define EFSCORRUPTED EUCLEAN
+
 struct udf_meta_data {
 	__u32	s_meta_file_loc;
 	__u32	s_mirror_file_loc;
-- 
2.39.2




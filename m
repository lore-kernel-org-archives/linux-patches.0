Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677A76FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:30:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF76C433D2;
	Tue, 10 Jan 2023 18:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673375455;
	bh=u3ScWIUxO3NcaVexuYMtFc5TdZEK44N1eLTM0uZlS3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dY7TSIP+icoQWL7wyQUOa+Lexl8Vp3sK0PJildFIRKQuyfwyBPf+E8To2cxkcN9mi
	 pztrZmKDqDdzl94s+WAqN66LqH+T6xGL4zzVy8UItCcfNgXbMKRIqlEpazzUoKJS+K
	 l3HVMj7EMuw5MrKRBZEohMorRFVsWUyNqrDDgCMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ritesh Harjani <riteshh@linux.ibm.com>,
	Jan Kara <jack@suse.cz>,
	Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Eric Biggers <ebiggers@google.com>
Subject: [PATCH 5.15 167/290] ext4: remove unused enum EXT4_FC_COMMIT_FAILED
Date: Tue, 10 Jan 2023 19:04:19 +0100
Message-Id: <20230110180037.673263016@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@kernel.org>

From: Ritesh Harjani <riteshh@linux.ibm.com>

commit c864ccd182d6ff2730a0f5b636c6b7c48f6f4f7f upstream.

Below commit removed all references of EXT4_FC_COMMIT_FAILED.
commit 0915e464cb274 ("ext4: simplify updating of fast commit stats")

Just remove it since it is not used anymore.

Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Link: https://lore.kernel.org/r/c941357e476be07a1138c7319ca5faab7fb80fc6.1647057583.git.riteshh@linux.ibm.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/fast_commit.h |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/ext4/fast_commit.h
+++ b/fs/ext4/fast_commit.h
@@ -93,7 +93,6 @@ enum {
 	EXT4_FC_REASON_RENAME_DIR,
 	EXT4_FC_REASON_FALLOC_RANGE,
 	EXT4_FC_REASON_INODE_JOURNAL_DATA,
-	EXT4_FC_COMMIT_FAILED,
 	EXT4_FC_REASON_MAX
 };
 



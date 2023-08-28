Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DE211C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:21:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59728C433C8;
	Mon, 28 Aug 2023 10:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218090;
	bh=MEDPTVfmOhLodtlxhNi1qEW/aZ9ng5k2uskBv2TreC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mP4XLAdEjsF+VpZNtg1Nh99/AnYKaERqdhE6uZuiiIkrTvOKclxYzBoW5H6BjjfIb
	 QMDkX6Mrw/LD3nxbhs7KIR7eEhdVUOE1g2d49kadln7fyk4lEEjjUqW7zHKLXHpzqv
	 fwatimxXajQfhTOiuQoja/V5CWj8G3SC8EDjv4LQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.4 091/129] selinux: set next pointer before attaching to list
Date: Mon, 28 Aug 2023 12:12:50 +0200
Message-ID: <20230828101200.373916257@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>
References: <20230828101157.383363777@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Göttsche <cgzones@googlemail.com>

commit 70d91dc9b2ac91327d0eefd86163abc3548effa6 upstream.

Set the next pointer in filename_trans_read_helper() before attaching
the new node under construction to the list, otherwise garbage would be
dereferenced on subsequent failure during cleanup in the out goto label.

Cc: <stable@vger.kernel.org>
Fixes: 430059024389 ("selinux: implement new format of filename transitions")
Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/ss/policydb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -2005,6 +2005,7 @@ static int filename_trans_read_helper(st
 		if (!datum)
 			goto out;
 
+		datum->next = NULL;
 		*dst = datum;
 
 		/* ebitmap_read() will at least init the bitmap */
@@ -2017,7 +2018,6 @@ static int filename_trans_read_helper(st
 			goto out;
 
 		datum->otype = le32_to_cpu(buf[0]);
-		datum->next = NULL;
 
 		dst = &datum->next;
 	}



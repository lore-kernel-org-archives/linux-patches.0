Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7131F155385;
	Tue, 18 Jun 2024 12:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715446; cv=none; b=mfZMLVSOTGxrkHKjPkk/l2uA8CvHsjXSxHvOzEqGyy+LiPZjPJ4jxfWUmOOnNzDikfh9w/ilEoAiQQ8DKJkQi9q6mahgsWLWIdZ/Uru80LvDvlAnfYyTYQWc9vRy5u4bUbZRNfgLc7DdGXabpsaYcnbHjvTSNhxvEI2Om9H8bI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715446; c=relaxed/simple;
	bh=QocPSJsB5C5CGuT+d8N7yeeHglMCA7LhjaKUcDnoTv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PgmXtwnhR5P76sRZp4qEQMuKfcpNX7skra+68y7RSp8GavlUHtFpb1JkUxkNBDOb7eEi1pQViqzJ/gCpQWSjnsYk4ZDEvzGtOK2IviiBuYiaToasirCv3OzmXGYR/QgUPcCBMwJNFn3t1zl0JF1S/moBxdRdeymyszEI6jHkT14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NIupr8u6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NIupr8u6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB962C3277B;
	Tue, 18 Jun 2024 12:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715446;
	bh=QocPSJsB5C5CGuT+d8N7yeeHglMCA7LhjaKUcDnoTv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NIupr8u6zNxyFPBt6wR1hKGxr1dFsQs1UgSLYGYLqcm5xC/4olRhOmM+Y1wKP3/KJ
	 N/YunxPKWm+4jt0NLqeuMg05EXO+/y6ohFzpy4RfVBJutIdTdJkzJ2iNqh6okt+ers
	 vp2RHlIGmliUOdpbdrkrPSTzkZOlOR9rkLVHRYZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 280/770] NFSD: Drop TRACE_DEFINE_ENUM for NFSD4_CB_<state> macros
Date: Tue, 18 Jun 2024 14:32:13 +0200
Message-ID: <20240618123418.071923268@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 167145cc64ce4b4b177e636829909a6b14004f9e ]

TRACE_DEFINE_ENUM() is necessary for enum {} but not for C macros.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/trace.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index de461c82dbf40..3683076e0fcd3 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -877,11 +877,6 @@ TRACE_EVENT(nfsd_cb_nodelegs,
 	TP_printk("client %08x:%08x", __entry->cl_boot, __entry->cl_id)
 )
 
-TRACE_DEFINE_ENUM(NFSD4_CB_UP);
-TRACE_DEFINE_ENUM(NFSD4_CB_UNKNOWN);
-TRACE_DEFINE_ENUM(NFSD4_CB_DOWN);
-TRACE_DEFINE_ENUM(NFSD4_CB_FAULT);
-
 #define show_cb_state(val)						\
 	__print_symbolic(val,						\
 		{ NFSD4_CB_UP,		"UP" },				\
-- 
2.43.0




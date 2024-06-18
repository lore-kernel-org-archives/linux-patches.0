Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A921534E9;
	Tue, 18 Jun 2024 12:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715378; cv=none; b=AerGphz7KXHYOSg1eM0imKlN9C2RwRlS38hdxbRGCORJKt7PTDSZjqVTCzkLcLXKQIgn1sN61EOIkDVna0lyXc3lXvro2lSppwTeklJZYfbQPX1CSVrJHEmu3oh+SYnBYCTbqTxTszjhLiPH4Axx7B3DtbmbJWsdquTho1tZNSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715378; c=relaxed/simple;
	bh=yWTXsF+xFkkQgz+n8RE50sP4F+jfDhYQOxT6gTRA1vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BNNF6fFxodb3qD3ClC53p+Y+s25SS+usuAjkhCLya9yxeN9SyCxStLpLsBe3rIp6crGsjbOQYhU9PJH/JNV4JOLKjgYKDPI7tqRrF8VRGli1oKdjAV4TqTErX9i/8E4Cw8IPg7gDqrkiYarxRuc580tkcE8eMet5hGoWJuelYOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QFyyDlmn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QFyyDlmn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1B51C3277B;
	Tue, 18 Jun 2024 12:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715378;
	bh=yWTXsF+xFkkQgz+n8RE50sP4F+jfDhYQOxT6gTRA1vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QFyyDlmnCpLJVUMdTZXmEqrig6GQgWl/G4tVGL/BOe0BF6lii2MGrUTCOG+Bt83VI
	 HCtG2RumRqLASJ/TU2k21MJikXEhfYNRG8AdIYR7ZjcuwE6w0Zsz4LmCdcq/Wp1JjR
	 gJxeCVLQenewkKiankOJ+MJqiB7S2A9emz3Co9MY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 289/770] NFSD: Update nfsd_cb_args tracepoint
Date: Tue, 18 Jun 2024 14:32:22 +0200
Message-ID: <20240618123418.417021659@linuxfoundation.org>
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

[ Upstream commit d6cbe98ff32aef795462a309ef048cfb89d1a11d ]

Clean-up: Re-order the display of IP address and client ID to be
consistent with other _cb_ tracepoints.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/trace.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 87ac1f19bfd0b..68a0fecdd5f46 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -857,9 +857,9 @@ TRACE_EVENT(nfsd_cb_args,
 		memcpy(__entry->addr, &conn->cb_addr,
 			sizeof(struct sockaddr_in6));
 	),
-	TP_printk("client %08x:%08x callback addr=%pISpc prog=%u ident=%u",
-		__entry->cl_boot, __entry->cl_id,
-		__entry->addr, __entry->prog, __entry->ident)
+	TP_printk("addr=%pISpc client %08x:%08x prog=%u ident=%u",
+		__entry->addr, __entry->cl_boot, __entry->cl_id,
+		__entry->prog, __entry->ident)
 );
 
 TRACE_EVENT(nfsd_cb_nodelegs,
-- 
2.43.0




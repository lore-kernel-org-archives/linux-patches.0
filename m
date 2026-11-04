Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831752;
	b=R1LIqqxkdAlv/jKcqhRlBkNouXp0ohNE/EjYFHGmPRLjrDn/Mb6X29CcZk7CK97sF0Ql
	 fJGI7WYdu18lOsE1TPmtBsj0QYK7xIzfiC4eiNM2haBBmO7R8oBAQaudGoZuDA/WwG5kG
	 6tXdsruEK7sKq02YX5oSgqntQvZYwR7k/7TQAg/FBG5yCK60wOY/8l4c27iMfv3uKxbvw
	 bz4TFsaKfTc2AjPgweiWlv0nRQ8z7ByIxOlvXEQkOeOfcIBuAk3TBic+tsuJd/fKmnfhk
	 ShmnCKztW+JrfuEVWjuCs1Z9HjEksBcly/l2SGb2xY47KyCm0yDUnokgCtADqNabA2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831752;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x/VrAqbSnB0EwWAe9oyvRScuhWy4YxsV9vTekWC+r00=;
	b=uDrHpgNgWmpQym6axznpdbBrUk3pDFCcAj51Yky7JK0V9SZWiWfp7qPH0bkilikt1JLa
	 Pfdd0UOoro4Os29fIQLsQeYDGiZML/DmZzyth+jyYq5FHduQbFufUZTLoI1cUS9/hdUjY
	 9yEJLA//1MSuJ1YAMzpTtKOkrKnjkOd5XNJi0zJerRWMHzQH8WMcAb8ai/nihGjzLJ/5E
	 WxWQhZMWdf/HHV1s4dxACTZ77pgAwl0+/ZC+mn0I+iJl08XQjmVsASBR4NYrzQsa+SH3Y
	 ZHrt4GC5MB8f53WkUW3u1brnbl1PuZD5Prg4s9rXo5zo1jXkSOE4O6oo/2Ij+c49XRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Og5X7gnB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB410606A31B;
	Wed,  4 Nov 2026 22:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Og5X7gnB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6285E1F00A02;
	Wed,  4 Nov 2026 22:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831751;
	bh=x/VrAqbSnB0EwWAe9oyvRScuhWy4YxsV9vTekWC+r00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Og5X7gnBXjflPPSOL6GQH6xnrkcDAc9yO39NJFGlnx35axeqPVbUE887wHZyjsgQi
	 VEYbKg5SOFIz4JikDyNuRKwsu0yTlp1Q+8FmM++RMRmam6bBUFy1pZR3v8APXxfclx
	 NGrzB1DIteJHK/xp86KQ0oGxBvjtaV6+M59/8UKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0846/1005] xfs: dont allow sm_agno for non-group metadir path checking
Date: Wed,  4 Nov 2026 16:09:39 -0500
Message-ID: <20261104211107.012562065@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 20c5a56bc4f2329872d21561e4a2d4b8576004c9 upstream.

LOLLM noticed that the metadata directory tree path checker accepts
non-zero values in the sm_agno field for non-group metadata.  Make that
case return -EINVAL.

Cc: stable@vger.kernel.org # v6.13
Fixes: a74923333d9c3b ("xfs: scrub metadir paths for rtgroup metadata")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/metapath.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -128,6 +128,8 @@ static int
 xchk_setup_metapath_rtdir(
 	struct xfs_scrub	*sc)
 {
+	if (sc->sm->sm_agno)
+		return -EINVAL;
 	if (!sc->mp->m_rtdirip)
 		return -ENOENT;
 
@@ -175,6 +177,8 @@ xchk_setup_metapath_quotadir(
 {
 	struct xfs_quotainfo	*qi = sc->mp->m_quotainfo;
 
+	if (sc->sm->sm_agno)
+		return -EINVAL;
 	if (!qi || !qi->qi_dirip)
 		return -ENOENT;
 
@@ -191,6 +195,8 @@ xchk_setup_metapath_dqinode(
 	struct xfs_quotainfo	*qi = sc->mp->m_quotainfo;
 	struct xfs_inode	*ip = NULL;
 
+	if (sc->sm->sm_agno)
+		return -EINVAL;
 	if (!qi)
 		return -ENOENT;
 



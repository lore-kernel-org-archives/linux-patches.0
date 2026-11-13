Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590877;
	b=DTUGp5CjBSpl98vwHvnBt5kgR6EfQXkgFcp9KM+mYfKP1FhzR3gkRvQZoSVlPjFYJFuo
	 FsVrsdHEQS9Rl+NZcz+T6+Os84kQbQGeH/j7gGq6/uqGlvZtPGnyQ3YPkq0k4HCYuPCjy
	 FoildkslCF2J74uQlAXfdncPree3T1eCFKHFRqFQgETltkaUIUKt+O1cnB8M7JZuFmz5I
	 QUACOspy/yk3vuyclFsbPL4J08+uAjCMOvUz4QNTZ9KT4OMKFG+wErqTVs51lqCRabHpX
	 RdzIBooMyiZg0XOhwZ68hJEEWoq1iNtX4FGljFslY+V5mxRbR0uew2XmzaerHYjx6zQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590877;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=06MxI6VppHp6+Zm7vAxoQvu2OxacKiPMbnSQuu95/uA=;
	b=HFRVViiSL0uGxgQBkfHGnD/yoa07Tq9sUS/wenn5lF26m/c9n1ipx4OacG9AohZSld1l
	 sD6iGYUfvoCp8fnzcOgwXcSonnzB4NDU4AHrEaFCYkNbYGthNJFy8aqdE9/A398ENlJy1
	 XeiKpIkVAayA+bmaWhDA9E7E8JQRtp8BaC5mZbxxmcE9O3LfaO6iudOCArN86LVYTt6sB
	 pk8bGi5QpiK3AHfoXxsQ8Hb77L5zGWndBFl7tIo0Je/0PPBVC9Iq6+LeUi4i3TdUGB6qk
	 MKjsflrIejFXpMZwA+BsvaHQI5qui1lGKvMFoUUrtiq+baWAASq1JDvdIJ2/LmdLaOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="LLCp/Pat";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84C8606D4B8;
	Fri, 13 Nov 2026 17:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LLCp/Pat
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E6D1F000C4;
	Fri, 13 Nov 2026 17:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590877;
	bh=06MxI6VppHp6+Zm7vAxoQvu2OxacKiPMbnSQuu95/uA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LLCp/PatbDzFjRSr06UMbPqc0jT+ngWi2dMw7fIR/I+l6gwPUjpuIjE/hoXuMSmTG
	 GiDmP4RB3YeyZYn+K9bBJBksQG0OZLuOWORaJxlfLCJ/q5Eu/D+eYY3ZU0oVp2lpax
	 h/Xem37D66luOm5TqfvqVeLQK5baO3un8oAwe64g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 073/670] xfs: complain loudly when dirtree checker finds broken links
Date: Fri, 13 Nov 2026 10:43:57 -0500
Message-ID: <20261113153814.023478929@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit e09438cab72c2c6a32665829d4186155346bfee8 ]

LOLLM observed that the directory tree walk code bails out if it finds
broken parent pointers along the way.  However, it flattens the return
code to zero, which means that we can end up in the repair code having
not completed the scan.  We should never proceed with a repair in this
state, so let's mark the scrub incomplete and exit.

Cc: stable@vger.kernel.org # v6.10
Fixes: 928b721a11789a ("xfs: teach online scrub to find directory tree structure problems")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ sashal: Retained xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino) instead of upstream's xchk_ip_xref_set_corrupt(sc, sc->ip). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/dirtree.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/dirtree.c b/fs/xfs/scrub/dirtree.c
index 8933506c4830a..35848cbfae929 100644
--- a/fs/xfs/scrub/dirtree.c
+++ b/fs/xfs/scrub/dirtree.c
@@ -849,7 +849,8 @@ xchk_dirtree_find_paths_to_root(
 				 * A parent pointer of @sc->ip is bad, don't
 				 * bother continuing.
 				 */
-				break;
+				xchk_set_incomplete(sc);
+				return error;
 			}
 			if (error == -ESTALE) {
 				/* This had better be an invalidation. */
@@ -970,6 +971,7 @@ xchk_dirtree(
 		 * parent pointers are corrupt; this scan cannot be completed
 		 * without full information.
 		 */
+		xchk_set_incomplete(sc);
 		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
 		error = 0;
 		goto out_scanlock;
-- 
2.53.0




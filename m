Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A836342C94;
	Mon, 18 Aug 2025 14:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526359; cv=none; b=aolkkmoEKj5xXL8dLVM332rj86VR9HO3xQfF2vSUUDRiwYlbWucuIMgOVgwrEET0cuPo9Xsi9JGEHh3pAg+x6gAeoy+Ez4V/kFzxR4Xf2PZ+1eImZ6Wx++Y47vvFHqT0w3T0TUqb52H1922pcCL5XAs2GphCndrrFjYnP/0HDYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526359; c=relaxed/simple;
	bh=6prqVYD421AV2O/jyLAlLC22S2JkaDM1KPMkZxTMavI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T7al03BKH8jJyAXb2Q4osn8nzC9qNlPo/9uSMCaPA+302R5d66ASJd0WnZ3TcAdAtVOteIHaMk45fyYJxA0wSjNlvpGzMoR6iwqQMS4L+lLn3cT0zEbnmCTNOkGDl+0a6RCtkgQVuzf5rDpT7EjKrF3Pzprp5Valxg0WzWZrusM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rlgA9vvx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rlgA9vvx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0924AC4CEEB;
	Mon, 18 Aug 2025 14:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526358;
	bh=6prqVYD421AV2O/jyLAlLC22S2JkaDM1KPMkZxTMavI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rlgA9vvxbQkRpyRyX5FnDBD3bDQfvGpAzqRTH4BKtHOX6emHQALFJshCR8PjhQwwB
	 tE4sjtZz3ZlhPGvr5yi392MYq1AbHEvTzrbbn78e11TZXNprGL+HOEhS2WGwn/H1UW
	 N/f1rf9jEcZOmqke+AjOOjLBMqzpbTC8LfouWYwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.16 533/570] xfs: fix scrub trace with null pointer in quotacheck
Date: Mon, 18 Aug 2025 14:48:40 +0200
Message-ID: <20250818124526.410988462@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Albershteyn <aalbersh@redhat.com>

commit 5d94b19f066480addfcdcb5efde66152ad5a7c0e upstream.

The quotacheck doesn't initialize sc->ip.

Cc: stable@vger.kernel.org # v6.8
Fixes: 21d7500929c8a0 ("xfs: improve dquot iteration for scrub")
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/trace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -479,7 +479,7 @@ DECLARE_EVENT_CLASS(xchk_dqiter_class,
 		__field(xfs_exntst_t, state)
 	),
 	TP_fast_assign(
-		__entry->dev = cursor->sc->ip->i_mount->m_super->s_dev;
+		__entry->dev = cursor->sc->mp->m_super->s_dev;
 		__entry->dqtype = cursor->dqtype;
 		__entry->ino = cursor->quota_ip->i_ino;
 		__entry->cur_id = cursor->id;



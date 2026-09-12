Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF424246BCD;
	Sat, 12 Sep 2026 10:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207401; cv=none; b=ebs7F52EeV1+JXZhrnghqdjKRbNyenqoQocNvEggiTFmT5zpryw9sFfrvH74AzIMjFtl4mfuorXMpRyD9dv1Urp6SOgGKPVN+awhONW35qCS0VW+B3yXwsMh3+1Q0qsA8zaQN6Dqj3MhYleFx8B03W59QdGEHMEOZeu7MzY+/OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207401; c=relaxed/simple;
	bh=WJxHEtOfQp8s3IqhMjjE+qbadjQNn3nwYtNV9NHkbsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hw1UY1mlfU1ToD1lRaXO1wxss9V0Ug1XefqO5E3b5dTf88dV/lqM6xYtdYdW04Nupos0HBnYBN9Zi3eVGeG8ttUph5iUJ1iQQk98gA+f8OlYqKMSF9SRCM9Ju/upBfoy/+zpLpNqUqN28rBE8rmQ4SqO6GJu5tYLjHFA8FBIVnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p+ah4dn2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p+ah4dn2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 808AD1F000FF;
	Sat, 12 Sep 2026 10:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207399;
	bh=zKzpaIR/gK7io4OrhD2ANdX5s104WyD+elJChCLuuTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p+ah4dn2Al9rN4kQeEaphSl4Czzw8mazlCi9Iq9DdfpY/V6RRj7fNsdK5hGYfUBD0
	 927ZS7jhEEAtBEDDnTmOcC0yEvFHpCi147FPFbY+jYGhwdrnO8Kn48b7KaxzpwKm6C
	 QIxyGMEVHxEZfTHaN8xant4HgHxgvJdZOgBBgktY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gleb Markov <markov.gi@npc-ksb.ru>,
	George Zhang <george.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0404/1518] drm/amd/display: Remove unused-but-set variable hubp from
Date: Sat, 12 Sep 2026 08:42:53 +0200
Message-ID: <20260912065632.595972861@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gleb Markov <markov.gi@npc-ksb.ru>

[ Upstream commit b736792e5bd4a62f24e8d1e310bf4a75bfbeaaaa ]

The final check of hubp for NULL covers all remaining lines of code, since
the value of hubp does not change until the end of the method.

This check is redundant because hubp1 is already dereferenced within the
macro.
If it were NULL, the program would have already failed to proceed.

Remove the left part of the expression with the logical "&&".

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: be1fb44389ca ("drm/amd/display: Check null pointers before used").
Signed-off-by: Gleb Markov <markov.gi@npc-ksb.ru>
Reviewed-by: George Zhang <george.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/hubp/dcn10/dcn10_hubp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hubp/dcn10/dcn10_hubp.c b/drivers/gpu/drm/amd/display/dc/hubp/dcn10/dcn10_hubp.c
index 9b026600b90e8..99625cba3df66 100644
--- a/drivers/gpu/drm/amd/display/dc/hubp/dcn10/dcn10_hubp.c
+++ b/drivers/gpu/drm/amd/display/dc/hubp/dcn10/dcn10_hubp.c
@@ -769,8 +769,7 @@ bool hubp1_is_flip_pending(struct hubp *hubp)
 	if (flip_pending)
 		return true;
 
-	if (hubp &&
-	    earliest_inuse_address.grph.addr.quad_part != hubp->request_address.grph.addr.quad_part)
+	if (earliest_inuse_address.grph.addr.quad_part != hubp->request_address.grph.addr.quad_part)
 		return true;
 
 	return false;
-- 
2.53.0




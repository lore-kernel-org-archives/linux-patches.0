Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE15D23760;
	Thu, 18 Jan 2024 11:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575775; cv=none; b=Afd73qVOfnXlWhiGZJrKQe7F2odKRPPt/dZp3jft014Wq89pKKG4Vee4wWZ19CMOQdJwNhVYv1xAClWFnGFNlS4f4XX9T1SJVmftYB0RahAcZCnxOs2M2+Ls8pMkC4TMhcWLq8l0VuuP/YNHz6JHOUDDy0rDj19Nj1ELEtdzTqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575775; c=relaxed/simple;
	bh=6okQUjYok/NysartlZSox2F7p1s8Mk2U3CbsB5gkQw4=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=GYwFKbMfcEyWRvJ3DSkK68dgu/FQpaUvS1kxqwrOshrvzlK7oDRK1C+M9d8TYUMzexyYjd6MzUbX2wTlrvzfvEidqfJpM1A8BAtE9v518j0yF/8JVYf6J6DZZEXjmXamiNde7p2tcEdTz9SX14tRAyk+jc/XtJbmIhSQVFiCAZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nVnS9wBi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nVnS9wBi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F84C433F1;
	Thu, 18 Jan 2024 11:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575775;
	bh=6okQUjYok/NysartlZSox2F7p1s8Mk2U3CbsB5gkQw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nVnS9wBi9+N/12V3Ht2ZNi7BoL5zRMx+l370JxWFc0qshvRhLIY6Er+1237xtPtCq
	 2nqP7KVWD6Fl8HVfHEjS+W9IWBQjZnviu7vs7a0pW5d2IqylVWeUU3o+P2fiaIwkQv
	 bLvOjnkSIBzzIIDYzC87L5v2tUkvcbnP/8/xiIhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 070/100] dm audit: fix Kconfig so DM_AUDIT depends on BLK_DEV_DM
Date: Thu, 18 Jan 2024 11:49:18 +0100
Message-ID: <20240118104313.990532027@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit 6849302fdff126997765d16df355b73231f130d4 ]

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 662d219c39bf..db0e97020256 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -650,6 +650,7 @@ config DM_ZONED
 
 config DM_AUDIT
 	bool "DM audit events"
+	depends on BLK_DEV_DM
 	depends on AUDIT
 	help
 	  Generate audit events for device-mapper.
-- 
2.43.0




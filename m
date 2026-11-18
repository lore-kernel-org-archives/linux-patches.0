Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033470;
	b=Y16U7Qpio9k36V8YtYCadL4zseaSiWUl+oXLD8vzOd0JyI98KQUyRp2wX/m5xe+N81j4
	 gVDSV9BULkGe2KvEl65L204Ppp8EnfrrSaTwTK86pklvrVF/Jxb8UQQINg6uieHEsYxZR
	 /MsWX1HGvYrbWfaO/Y1maB1HiXGoT89MG4NSQRkj/1jyJLkQH8KjdAp9QQHFLqQqqy1XO
	 4ny14UhkmFGlxTPDW+mil5Z7YEXWV7HqZ0/L0h4qd8E2zUNe8lPksaX3Px1mYE/14vH/l
	 +NhX8iNqw1DkkV4ZBmFj5AtBVAjI30vBwJ3nHU/YG+XUGHypGbGOigdJETSNdzQrZag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033470;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GnlV39MbKMyh0V0EnjukrNNgBms6AiEBpG259AjWX1g=;
	b=Akod8112vM5/+1bs+PnJPmbnefWk0mBlU0p0bcwCEL2vgnvPvSkEd4iwsvoEN4nQjGKH
	 lZeqa1QRdw32Di3Xl4Ut8YpQfKzakycrnMLcSlE4AaBW16dLiwUIVC2xKoebKhPk/9Uiz
	 JvPG0hwGCh6lX+QmgToSVJ+I9fNp51m8WNN0Htegx5/zS5BlRKIHUSrGQ3UAJwoAplkiq
	 2HZzqSTDPD08CxFUnPwNzIEbV2Ovbp51aIj4o9vyzMDwpJW2yWWjH1nyfz2g3Af5blxkW
	 w848QYK0znulJedtN+Lme2ysF5twxuizvkGlgK7XwYtqNpxwTM4hYDGK5+72V42rTbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2WDWy1vL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B430F606A31C;
	Wed, 18 Nov 2026 20:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2WDWy1vL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12BBD1F000C4;
	Wed, 18 Nov 2026 20:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033470;
	bh=GnlV39MbKMyh0V0EnjukrNNgBms6AiEBpG259AjWX1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2WDWy1vL0JsIyGINI3xJ2HzCJ2eGsmNzULPUA+mlgepDhFDKc5EihNghhD+IQSadZ
	 HsUJ0DoDCExCMfJtJa8bCl0aOYhfYXj6K0t2KY7UPVCgVOYdzAQnZuNciKsBWi0LV0
	 N0YQIuhqZB+ZDfXebiNqKU6DhIOcwn0DwSn/jUZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0008/3318] mm/damon/sysfs: put target pids for apply_inputs() failure
Date: Wed, 18 Nov 2026 15:10:30 +0100
Message-ID: <20261118150313.888322697@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

damon_sysfs_build_ctx() invokes damon_sysfs_apply_inputs() for setting
damon_ctx object with user inputs.  If it is configured for virtual
address spaces monitoring, the setup also increases reference counts of
monitoring target pids.  If the setup is failed, damon_sysfs_build_ctx()
deallocates the damon_ctx object without decreasing the reference counts
of the pids.  If the failure happened after increasing reference counts
of pids, the pids can be leaked.

Fix the leaks by decreasing the pid reference counts before deallocating
the damon_ctx object.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260730040740.140836-1-sj@kernel.org

Fixes: 74bd8b7d2f8e ("mm/damon/sysfs: move targets setup code to a separated function")
Cc: <stable@vger.kernel.org> # 5.19.x
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index d95fda1054a00..f830b873d05fc 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1433,6 +1433,7 @@ static struct damon_ctx *damon_sysfs_build_ctx(
 
 	err = damon_sysfs_apply_inputs(ctx, sys_ctx);
 	if (err) {
+		damon_sysfs_destroy_targets(ctx);
 		damon_destroy_ctx(ctx);
 		return ERR_PTR(err);
 	}
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6312676CA;
	Tue,  8 Apr 2025 12:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113807; cv=none; b=sodFNvpPiVJ/b8gppZtgZy1vO7EU9wZ6cOT7D4WIErw7erfShVI6L3BFTThGFrdOIiJyFZXSvLtCxQbNwggBKMpakjO83doFq5xUQfadeAiAEmfCa/0KYs6zcRJN2rjJO02TA4tgpTqoWtHHzm1PfvoT6A5wsD/n2UKtDTBifWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113807; c=relaxed/simple;
	bh=6jYRH2rFpLI1exDO6dQSAls/jmY4fQdbE4PFO8ZgDgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HbM5CmWpb2vJ3cch167C0c+O2/8d1GG+WS/xNd+pcjdhzdC6iU/X8D9eXynmLiQevTjP4RXJ1akvxsTHg8IGKsfOJ6n9SlQB3NxNT5crJv1XLbvSbvSxEYQg5vBMJXMMxnEJWaZt8fch8BotYOyCTCBV+e/nHnKAzL1dVF3oazM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cjFcAz78; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cjFcAz78"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FFF7C4CEE5;
	Tue,  8 Apr 2025 12:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113806;
	bh=6jYRH2rFpLI1exDO6dQSAls/jmY4fQdbE4PFO8ZgDgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cjFcAz78dIbTvZCr30uNksg9454Gm4dkHlNd5Rvm4AZ2j7TOW/d78g56pkBh2JBOQ
	 4Xsny//sGQNDOHfDA4nECAR4xI0zkkQ/velvGcsBIniUjikBHhZAJGSAaTQlKacDl8
	 FF9HY0VIQE5pGUARSt8Wz1dylNKKBmNZv1ZbJMFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Magali Lemes <magali.lemes@canonical.com>
Subject: [PATCH 5.4 004/154] Revert "sctp: sysctl: cookie_hmac_alg: avoid using current->nsproxy"
Date: Tue,  8 Apr 2025 12:49:05 +0200
Message-ID: <20250408104815.433896809@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Magali Lemes <magali.lemes@canonical.com>

This reverts commit 1031462a944ba0fa83c25ab1111465f8345b5589 as it
was backported incorrectly.
A subsequent commit will re-backport the original patch.

Signed-off-by: Magali Lemes <magali.lemes@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sysctl.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -441,8 +441,7 @@ static int proc_sctp_do_auth(struct ctl_
 			     void __user *buffer, size_t *lenp,
 			     loff_t *ppos)
 {
-	struct net *net = container_of(ctl->data, struct net,
-				       sctp.sctp_hmac_alg);
+	struct net *net = current->nsproxy->net_ns;
 	struct ctl_table tbl;
 	int new_value, ret;
 



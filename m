Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410D3334695;
	Sat, 30 May 2026 17:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162150; cv=none; b=HsADRHgIrH9O3kRC3dJL0JYTzGWX8xHWXQom6P2xtAq4374aUREQBOnmyYTEionw2zaP6ZSO2PTAEEPk0P4/7uJxKSJnv7bHfuJb+4Zdkf44T5fPQ5ZwI+EG/mKBOnWMCzDrFET2K3jUWRO+PcrBmbpoz84owzefP6BvhzwtslE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162150; c=relaxed/simple;
	bh=Gtjsna/1pC4rOGpk3kT5RYO39mjRhB78YEnuSWgsAmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HjDAwgl9IMfrtB+wZxOR/pKXL5LXTYqP7e7UagZT4mh/LG8CspiEwEwQaceV3zidwpGd1QaEwGevoYe4dCdWLxlQNKTPKC82rotoaO0CAWSz+/mSfTgxz8SZ+x3wHujcFAM76Q3ShLhkubdeF8LKdBjqWkqevkChFvT3huwxhqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zqakyuUQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zqakyuUQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 865AF1F00893;
	Sat, 30 May 2026 17:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162149;
	bh=yqsyBXJ4SuCd0gKtnJnMNiyc7FoSNR0D+MKyzBrBnnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zqakyuUQuswNshNtIDB+/veFKDjZlvLtrE+QXo+mYifhV4SQoVQkYr4TsOBu2kRmj
	 cICaoNcJMAZtle3/gMCqU7xO+vLTmagS+0TUl8hOKImMlzRpITgFv5Am7sq8c1uAOE
	 p81LeDu6rcWsg1lAePHUyQMP0jbK5FIjQA6TOV0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 836/969] Revert "s390/cio: Fix device lifecycle handling in css_alloc_subchannel()"
Date: Sat, 30 May 2026 18:06:00 +0200
Message-ID: <20260530160323.734776614@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit fd295a75d828c11acfcc6869c2a12cdaaf9b7722.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/css.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index 85c1734ebfe88..98a14c1f3d672 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -247,7 +247,7 @@ struct subchannel *css_alloc_subchannel(struct subchannel_id schid,
 err_lock:
 	kfree(sch->lock);
 err:
-	put_device(&sch->dev);
+	kfree(sch);
 	return ERR_PTR(ret);
 }
 
-- 
2.53.0




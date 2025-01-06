Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23F260890;
	Mon,  6 Jan 2025 15:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177879; cv=none; b=KO/FZulGf+OmNcsN+EitYfqqCPVHpZEibMVFLQTRiDinhys5cWVmnFve6QSzws8GH5ljIKHYLZ7eb6Kgi0NGFZy+8JQRciAAjgFWy/KQHr/022hP5Dba6N/Tbpp3BZXLvkPTMvihe/2ZbRDT++gHFZcHMTX/Ozso5z3vLpXm2k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177879; c=relaxed/simple;
	bh=1tyv8IA88LVRHITAFtvGZJdEUU4VxlsZpIL9W/caElU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EllbNHRDeFn2DXH+5CToKMZSW7JoAWhqpNvMTnOw9kg2A4Pc7RPYENwPdXtUJxBkYuMfeHM+Lo0/NaZh8Bchwv5S5MEGplcicE+4nVZ37f9TriEwSwqEUcEtjTLACPKEZhImhFKA9GuX+EXDyCXKJeXxchAfgsRywYBi9flyk9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qjC8lrlB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qjC8lrlB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A338C4CED2;
	Mon,  6 Jan 2025 15:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177879;
	bh=1tyv8IA88LVRHITAFtvGZJdEUU4VxlsZpIL9W/caElU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qjC8lrlBVn/crHdHqEQIEBUztMNGuVckrHLTZrBgr1Dxd++aX6nMXuzwL/aDZ0LFE
	 oRD4QN2GYDybPScVrOIPQXLsc7jCYTmlyZbHG/Kj/FU6l4xU1ul0StAeoIEH42bKNu
	 lhx58sQgZBpmxchSR8/i/TSi+7RndwcpDDH3Ekrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 056/156] workqueue: add printf attribute to __alloc_workqueue()
Date: Mon,  6 Jan 2025 16:15:42 +0100
Message-ID: <20250106151143.843802232@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit d57212f281fda9056412cd6cca983d9d2eb89f53 ]

Fix a compiler warning with W=1:
kernel/workqueue.c: error:
function ‘__alloc_workqueue’ might be a candidate for ‘gnu_printf’
format attribute[-Werror=suggest-attribute=format]
 5657 |  name_len = vsnprintf(wq->name, sizeof(wq->name), fmt, args);
      |  ^~~~~~~~

Fixes: 9b59a85a84dc ("workqueue: Don't call va_start / va_end twice")
Signed-off-by: Su Hui <suhui@nfschina.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 9949ffad8df0..25bdd9af7eb6 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -5627,6 +5627,7 @@ static void wq_adjust_max_active(struct workqueue_struct *wq)
 	} while (activated);
 }
 
+__printf(1, 0)
 static struct workqueue_struct *__alloc_workqueue(const char *fmt,
 						  unsigned int flags,
 						  int max_active, va_list args)
-- 
2.39.5




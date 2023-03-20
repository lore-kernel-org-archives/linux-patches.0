Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E281C1C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:12:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6409FC433EF;
	Mon, 20 Mar 2023 15:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325127;
	bh=u62PHWIrN6HTCJZD7dyHy2je/j/PdhGkuo2ogWvA/hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bi7BII/gYWVhkyxoaCHqLl99TiudyG6ZSSCyPWwAfJQQMh+RcEFQCSVOmvcM70FL+
	 HsFSIG9PD3iHQsYqyeXnLd/3VUXZVhPG2ty/QyMWRmWm02lq2/qh8oW8sSzf6mfWm7
	 wE67gvR0JxisnBR4BqdLNUpew8la4Wu99MAwFfRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 070/115] net/9p: fix bug in client create for .L
Date: Mon, 20 Mar 2023 15:54:42 +0100
Message-Id: <20230320145452.358993165@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Van Hensbergen <ericvh@kernel.org>

[ Upstream commit 3866584a1c56a2bbc8c0981deb4476d0b801969e ]

We are supposed to set fid->mode to reflect the flags
that were used to open the file.  We were actually setting
it to the creation mode which is the default perms of the
file not the flags the file was opened with.

Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
Reviewed-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index 08e0c9990af06..c4c1e44cd7ca3 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1315,7 +1315,7 @@ int p9_client_create_dotl(struct p9_fid *ofid, const char *name, u32 flags,
 		 qid->type, qid->path, qid->version, iounit);
 
 	memmove(&ofid->qid, qid, sizeof(struct p9_qid));
-	ofid->mode = mode;
+	ofid->mode = flags;
 	ofid->iounit = iounit;
 
 free_and_error:
-- 
2.39.2




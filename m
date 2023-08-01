Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6721ED30
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB11C433C8;
	Tue,  1 Aug 2023 09:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883413;
	bh=8HpwwKDOchzyf9YRaW2hYZj5dlLXrLKoNrFLKdosg+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VZ7gH9t5Gb9FVJybWe/rXXwF9evgn2BgyMpLJ0TNXEkD5enqqfP6UY7ZTEDNJzq6W
	 76wqrnt+9NvQTEKffF5swuU6G8JSUVmRzYGOlEQDOAd75mCrKDxWzvny34kvflb54P
	 rk0IjA0JuIKs24D8OWqM6j+SwXjAKFbhTP76Y8A4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Venky Shankar <vshankar@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.4 228/239] ceph: never send metrics if disable_send_metrics is set
Date: Tue,  1 Aug 2023 11:21:32 +0200
Message-ID: <20230801091934.177409684@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiubo Li <xiubli@redhat.com>

commit 50164507f6b7b7ed85d8c3ac0266849fbd908db7 upstream.

Even the 'disable_send_metrics' is true so when the session is
being opened it will always trigger to send the metric for the
first time.

Cc: stable@vger.kernel.org
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/metric.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -208,7 +208,7 @@ static void metric_delayed_work(struct w
 	struct ceph_mds_client *mdsc =
 		container_of(m, struct ceph_mds_client, metric);
 
-	if (mdsc->stopping)
+	if (mdsc->stopping || disable_send_metrics)
 		return;
 
 	if (!m->session || !check_session_state(m->session)) {



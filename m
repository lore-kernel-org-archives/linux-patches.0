Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BED7BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:18:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1C7C433D2;
	Tue,  7 Mar 2023 18:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213134;
	bh=o9GCGmwgky6r46sSOipycLCBaLT4QRcMERkXOGxX7KU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iXCfLSQO6hFxVRcZrr9U+GWjV98JaKaT4tM655WtVBCUi18qQ0Ltud0pLPPJeFVUE
	 5q+DpmeNtCgGGd7LOWyyHbV2xSrcBYWjxqonP9YaI1/tC9S/MbkhVcdaAePW0GKNFY
	 4s81bhjn7XIBQLnKuQ3qBcB7j7kJTKdAFQif9ghE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 380/885] NFSD: copy the whole verifier in nfsd_copy_write_verifier
Date: Tue,  7 Mar 2023 17:55:14 +0100
Message-Id: <20230307170018.842024129@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 90d2175572470ba7f55da8447c72ddd4942923c4 ]

Currently, we're only memcpy'ing the first __be32. Ensure we copy into
both words.

Fixes: 91d2e9b56cf5 ("NFSD: Clean up the nfsd_net::nfssvc_boot field")
Reported-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfssvc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 8b1afde192118..6b20f285f3ca6 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -357,7 +357,7 @@ void nfsd_copy_write_verifier(__be32 verf[2], struct nfsd_net *nn)
 
 	do {
 		read_seqbegin_or_lock(&nn->writeverf_lock, &seq);
-		memcpy(verf, nn->writeverf, sizeof(*verf));
+		memcpy(verf, nn->writeverf, sizeof(nn->writeverf));
 	} while (need_seqretry(&nn->writeverf_lock, seq));
 	done_seqretry(&nn->writeverf_lock, seq);
 }
-- 
2.39.2




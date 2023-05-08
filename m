Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830FE168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:11:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9781C433D2;
	Mon,  8 May 2023 11:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544316;
	bh=EntWdMyeiyAyFnSO1MQ5T/oUIXHBTYpC4ZPrGX4U+jQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DjsHdY0V8kilVSwa1BrN2ig6XRZYCbrBSb0xu+FcrwlZwPCRphGkqzKKsZk4CbGik
	 BaTHHUeNJwCFaA/eE4r040TkWPu8vx3QXxX3MQd5dP9u48HRy3iWZQx7/TjO2zkaLf
	 Ze8fHLtHTT4jZ3Ld2Wk+cQWzTN2xcVVGulwE7MTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bobby Eshleman <bobby.eshleman@bytedance.com>,
	Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 370/694] testing/vsock: add vsock_perf to gitignore
Date: Mon,  8 May 2023 11:43:25 +0200
Message-Id: <20230508094444.802336088@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bobby Eshleman <bobby.eshleman@bytedance.com>

[ Upstream commit 24265c2c91ad6aae9446e18472566cd83e92b602 ]

This adds the vsock_perf binary to the gitignore file.

Fixes: 8abbffd27ced ("test/vsock: vsock_perf utility")
Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
Reviewed-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://lore.kernel.org/r/20230327-vsock-add-vsock-perf-to-ignore-v1-1-f28a84f3606b@bytedance.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/vsock/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/vsock/.gitignore b/tools/testing/vsock/.gitignore
index 87ca2731cff94..a8adcfdc292ba 100644
--- a/tools/testing/vsock/.gitignore
+++ b/tools/testing/vsock/.gitignore
@@ -2,3 +2,4 @@
 *.d
 vsock_test
 vsock_diag_test
+vsock_perf
-- 
2.39.2




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632C917AAD
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:38:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96BC2C433C8;
	Wed,  9 Aug 2023 11:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691581126;
	bh=2rbq0vnRLg0p9titIcBt2FZ7Z9yXVrWtZY7aLjEDz1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TAiYdVKnB3Py72KRU/+5l/6ysoXoLt2XJfme4mr8/swNIlx93bZji2/rdhkyAtB5o
	 mBJ8aJ7xbrNskAheWB5VPz74mtt3BWXFz41wfDAbf8ckagUjeJ6SbNS6/guhKe55Sk
	 T9ftKM+BP2rmjVw4LHJv79qloNA2taVEcilq0Ugo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Li Huafei <lihuafei1@huawei.com>
Subject: [PATCH 5.10 113/201] kprobes/x86: Fix fall-through warnings for Clang
Date: Wed,  9 Aug 2023 12:41:55 +0200
Message-ID: <20230809103647.566643368@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103643.799166053@linuxfoundation.org>
References: <20230809103643.799166053@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>

[ Upstream commit e689b300c99ca2dd80d3f662e19499bba27cda09 ]

In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
by explicitly adding a break statement instead of just letting the code
fall through to the next case.

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Li Huafei <lihuafei1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/kprobes/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -880,6 +880,7 @@ static void resume_execution(struct kpro
 			p->ainsn.boostable = true;
 			goto no_change;
 		}
+		break;
 	default:
 		break;
 	}



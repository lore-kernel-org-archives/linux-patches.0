Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53718F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 15:01:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC0CC433D2;
	Mon, 13 Feb 2023 15:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300484;
	bh=MR/kAdflOEhns2wWlMYM/lsSbRZCkzPNXCRCtKITWiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WWbRe+w+/U26obRt08D3R6DEEP14bI+XQ8Y79JYNa+q5hwG16v2mjIT50LZA/kzse
	 uCiFcPSeUcpgBASWK+mOyKo/T79AetGVBIUFdyz/2eciQsjvHZxleI0bRUN/sn7bSi
	 b4hmja3mOGjkGEg0ftn8JQ3IdlE8jS3JNupgVcCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Gherzan <andrei.gherzan@canonical.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/139] selftests: net: udpgso_bench_rx/tx: Stop when wrong CLI args are provided
Date: Mon, 13 Feb 2023 15:49:36 +0100
Message-Id: <20230213144747.288990922@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrei Gherzan <andrei.gherzan@canonical.com>

[ Upstream commit db9b47ee9f5f375ab0c5daeb20321c75b4fa657d ]

Leaving unrecognized arguments buried in the output, can easily hide a
CLI/script typo. Avoid this by exiting when wrong arguments are provided to
the udpgso_bench test programs.

Fixes: 3a687bef148d ("selftests: udp gso benchmark")
Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>
Cc: Willem de Bruijn <willemb@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/20230201001612.515730-2-andrei.gherzan@canonical.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/udpgso_bench_rx.c | 2 ++
 tools/testing/selftests/net/udpgso_bench_tx.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/tools/testing/selftests/net/udpgso_bench_rx.c b/tools/testing/selftests/net/udpgso_bench_rx.c
index d0895bd1933f..4058c7451e70 100644
--- a/tools/testing/selftests/net/udpgso_bench_rx.c
+++ b/tools/testing/selftests/net/udpgso_bench_rx.c
@@ -336,6 +336,8 @@ static void parse_opts(int argc, char **argv)
 			cfg_verify = true;
 			cfg_read_all = true;
 			break;
+		default:
+			exit(1);
 		}
 	}
 
diff --git a/tools/testing/selftests/net/udpgso_bench_tx.c b/tools/testing/selftests/net/udpgso_bench_tx.c
index f1fdaa270291..b47b5c32039f 100644
--- a/tools/testing/selftests/net/udpgso_bench_tx.c
+++ b/tools/testing/selftests/net/udpgso_bench_tx.c
@@ -490,6 +490,8 @@ static void parse_opts(int argc, char **argv)
 		case 'z':
 			cfg_zerocopy = true;
 			break;
+		default:
+			exit(1);
 		}
 	}
 
-- 
2.39.0




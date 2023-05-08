Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E131171A8
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:37:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00535C433D2;
	Mon,  8 May 2023 11:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545869;
	bh=WzX49OhwakmUby6LoSKSVcP9ojRGrNGMXs2Kok2j3oQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jo9JCTLm/3IoouK0+NQhLrGU+EhNatxKb1hMN8UaNIfJ+yCSB96wYb43O0iLym6qh
	 PYa/392yveRHGKUW+FDMS79HYqGKGLi5Mat1c8l8G0KsBiw3uSMc8StjUFTUFvDo8L
	 KQJ/UT/JlWesoUv7DK6chkSefVCqY5uC4HUpv9X4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <mani@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 180/371] net: qrtr: correct types of trace event parameters
Date: Mon,  8 May 2023 11:46:21 +0200
Message-Id: <20230508094819.286195587@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Simon Horman <horms@kernel.org>

[ Upstream commit 054fbf7ff8143d35ca7d3bb5414bb44ee1574194 ]

The arguments passed to the trace events are of type unsigned int,
however the signature of the events used __le32 parameters.

I may be missing the point here, but sparse flagged this and it
does seem incorrect to me.

  net/qrtr/ns.c: note: in included file (through include/trace/trace_events.h, include/trace/define_trace.h, include/trace/events/qrtr.h):
  ./include/trace/events/qrtr.h:11:1: warning: cast to restricted __le32
  ./include/trace/events/qrtr.h:11:1: warning: restricted __le32 degrades to integer
  ./include/trace/events/qrtr.h:11:1: warning: restricted __le32 degrades to integer
  ... (a lot more similar warnings)
  net/qrtr/ns.c:115:47:    expected restricted __le32 [usertype] service
  net/qrtr/ns.c:115:47:    got unsigned int service
  net/qrtr/ns.c:115:61: warning: incorrect type in argument 2 (different base types)
  ... (a lot more similar warnings)

Fixes: dfddb54043f0 ("net: qrtr: Add tracepoint support")
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20230402-qrtr-trace-types-v1-1-92ad55008dd3@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/qrtr.h | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/include/trace/events/qrtr.h b/include/trace/events/qrtr.h
index b1de14c3bb934..441132c67133f 100644
--- a/include/trace/events/qrtr.h
+++ b/include/trace/events/qrtr.h
@@ -10,15 +10,16 @@
 
 TRACE_EVENT(qrtr_ns_service_announce_new,
 
-	TP_PROTO(__le32 service, __le32 instance, __le32 node, __le32 port),
+	TP_PROTO(unsigned int service, unsigned int instance,
+		 unsigned int node, unsigned int port),
 
 	TP_ARGS(service, instance, node, port),
 
 	TP_STRUCT__entry(
-		__field(__le32, service)
-		__field(__le32, instance)
-		__field(__le32, node)
-		__field(__le32, port)
+		__field(unsigned int, service)
+		__field(unsigned int, instance)
+		__field(unsigned int, node)
+		__field(unsigned int, port)
 	),
 
 	TP_fast_assign(
@@ -36,15 +37,16 @@ TRACE_EVENT(qrtr_ns_service_announce_new,
 
 TRACE_EVENT(qrtr_ns_service_announce_del,
 
-	TP_PROTO(__le32 service, __le32 instance, __le32 node, __le32 port),
+	TP_PROTO(unsigned int service, unsigned int instance,
+		 unsigned int node, unsigned int port),
 
 	TP_ARGS(service, instance, node, port),
 
 	TP_STRUCT__entry(
-		__field(__le32, service)
-		__field(__le32, instance)
-		__field(__le32, node)
-		__field(__le32, port)
+		__field(unsigned int, service)
+		__field(unsigned int, instance)
+		__field(unsigned int, node)
+		__field(unsigned int, port)
 	),
 
 	TP_fast_assign(
@@ -62,15 +64,16 @@ TRACE_EVENT(qrtr_ns_service_announce_del,
 
 TRACE_EVENT(qrtr_ns_server_add,
 
-	TP_PROTO(__le32 service, __le32 instance, __le32 node, __le32 port),
+	TP_PROTO(unsigned int service, unsigned int instance,
+		 unsigned int node, unsigned int port),
 
 	TP_ARGS(service, instance, node, port),
 
 	TP_STRUCT__entry(
-		__field(__le32, service)
-		__field(__le32, instance)
-		__field(__le32, node)
-		__field(__le32, port)
+		__field(unsigned int, service)
+		__field(unsigned int, instance)
+		__field(unsigned int, node)
+		__field(unsigned int, port)
 	),
 
 	TP_fast_assign(
-- 
2.39.2




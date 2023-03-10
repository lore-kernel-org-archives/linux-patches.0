Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F374882B
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:14:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE5FC433A4;
	Fri, 10 Mar 2023 15:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678461251;
	bh=CUExKGZIsAzNMWje0ARL+x7IVsi4LQTxN4RYSuWUoU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SitUT7fiaOg9AqEm6Q5vN8iDFGZjauge20oo+9peY7fmI21+DMGo8rGcxbOvxYQKg
	 1diz5udSBDBo2K26vESkhiV84fQ7xZSIOYPxAImz3MQhIGBJkKR643pVTDmIiIjahA
	 S06AuVZ0KTu+LUBez71J2TqBIIsmq+I3XsxTnBaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Souradeep Chowdhury <quic_schowdhu@quicinc.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 076/136] bootconfig: Increase max nodes of bootconfig from 1024 to 8192 for DCC support
Date: Fri, 10 Mar 2023 14:43:18 +0100
Message-Id: <20230310133709.455388957@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Souradeep Chowdhury <quic_schowdhu@quicinc.com>

[ Upstream commit 6c40624930c58529185a257380442547580ed837 ]

The Data Capture and Compare(DCC) is a debugging tool that uses the bootconfig
for configuring the register values during boot-time. Increase the max nodes
supported by bootconfig to cater to the requirements of the Data Capture and
Compare Driver.

Link: https://lore.kernel.org/all/1674536682-18404-1-git-send-email-quic_schowdhu@quicinc.com/

Signed-off-by: Souradeep Chowdhury <quic_schowdhu@quicinc.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bootconfig.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/bootconfig.h b/include/linux/bootconfig.h
index 537e1b991f115..5296fbb8408ca 100644
--- a/include/linux/bootconfig.h
+++ b/include/linux/bootconfig.h
@@ -49,7 +49,7 @@ struct xbc_node {
 /* Maximum size of boot config is 32KB - 1 */
 #define XBC_DATA_MAX	(XBC_VALUE - 1)
 
-#define XBC_NODE_MAX	1024
+#define XBC_NODE_MAX	8192
 #define XBC_KEYLEN_MAX	256
 #define XBC_DEPTH_MAX	16
 
-- 
2.39.2




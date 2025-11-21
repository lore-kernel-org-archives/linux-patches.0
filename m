Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21EB8348477;
	Fri, 21 Nov 2025 13:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732831; cv=none; b=qp44UB13xaMm4ckzpyS+DEtqPc8cRlMkF/GEBR8O+KRVQAEkzbGNDnWSuVFZ7zSMPNO4iRRxOMF3Rds1l2oi2Qgqj7caDdW+a0IXHKhnL5JOvqe+AU1uv2KscVRKTIZPIGm9r9qNkWt98FBEU9k8YOnCvKccvd/EN6ICU1ZaEVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732831; c=relaxed/simple;
	bh=569cKED5YPiWBQtebNj57+TIzXNinasQB27iVu3dXDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tm8VV0Glw7CKTyUXUwIoyw+eyzP6W6mA43owDm4mZGkOeb3nbVJMIffvaemptSn+QmUOPS+i2b1GScgpJ1LWE/L9OKVa9+ULmxx/cytYL2/cqrVmfdr7ajhWB+grNYHM8I7gBLara8LekAXwyLIXa/Q9VnT1EIZbp0JPGNqb64U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iKY2SVX+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iKY2SVX+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F85C4CEF1;
	Fri, 21 Nov 2025 13:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732830;
	bh=569cKED5YPiWBQtebNj57+TIzXNinasQB27iVu3dXDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iKY2SVX+EAyovcW1LlIwctuHPTRjSZgVbFgBVbKSVhuQ2+j7YtmoGbpDJ/OsjwmE3
	 TngixTBcCc32gGvRFqKb4HVajiV8vIDWV/d7uOqWiUego4Yq7UNGWClwN0q8rL0HDm
	 bub5CvXSiIxN6RvnZ4x/N2jF+IZGFWKhXqvJfHlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nai-Chen Cheng <bleach1827@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 241/529] selftests/Makefile: include $(INSTALL_DEP_TARGETS) in clean target to clean net/lib dependency
Date: Fri, 21 Nov 2025 14:09:00 +0100
Message-ID: <20251121130239.592510095@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nai-Chen Cheng <bleach1827@gmail.com>

[ Upstream commit d3f7457da7b9527a06dbcbfaf666aa51ac2eeb53 ]

The selftests 'make clean' does not clean the net/lib because it only
processes $(TARGETS) and ignores $(INSTALL_DEP_TARGETS). This leaves
compiled objects in net/lib after cleaning, requiring manual cleanup.

Include $(INSTALL_DEP_TARGETS) in clean target to ensure net/lib
dependency is properly cleaned.

Signed-off-by: Nai-Chen Cheng <bleach1827@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Simon Horman <horms@kernel.org> # build-tested
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://patch.msgid.link/20250910-selftests-makefile-clean-v1-1-29e7f496cd87@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 5b61b8bb29f84..a670d5de302b9 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -269,7 +269,7 @@ gen_tar: install
 	@echo "Created ${TAR_PATH}"
 
 clean:
-	@for TARGET in $(TARGETS); do \
+	@for TARGET in $(TARGETS) $(INSTALL_DEP_TARGETS); do \
 		BUILD_TARGET=$$BUILD/$$TARGET;	\
 		$(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET clean;\
 	done;
-- 
2.51.0




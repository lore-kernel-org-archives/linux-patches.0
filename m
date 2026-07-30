Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B5A217723;
	Thu, 30 Jul 2026 15:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424701; cv=none; b=qZteHeO1sPpFA1VH3kqzOlfyhxpPtOk2P7fh4B1rgqZqj/yninVUEmSghiycmNeZPbN0OrzFdT9x/Xto9a+cfKM/E5wjka7sfw0Qh04+xVTvRc+mNRtAjf07wSj1K2elzfnX0wxXdRIwBo8FTWn0A3b2w3yuEcaOocAiGKre5ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424701; c=relaxed/simple;
	bh=/X/ihY7p11nNgVkp/gWvdZiGedqvFGNNmnDSmYoxdtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sK0MAnvrO3O/4FKLWlGtFBjO/Z7FnFkGzPL0FcYcIAh2nHgJjgg5Ey1BQyLnu6Sdkf5nd5mz63LG2ntgXHsObAT+QuAYAfw4IrLwrEaIQXrxP5M1XRDE1gRi+xzPkptrBXUGjd06BVMdujsu31ZaJAmLyZ+Q3Y3zLm3+aMJrDm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yt/JPUtl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yt/JPUtl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E202B1F00A3A;
	Thu, 30 Jul 2026 15:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424700;
	bh=XeOpFNlvhTvYw0nUlTUqATDST/7irn2+nt8Oa3I8A+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yt/JPUtlChxKZoa7q07iIb9VEdrj1/MSFqx0ap+sgtp4mK1cE2oRB1JoLgxzX0fwl
	 waPYbard74mQQhHPtJCTCYJf3tiH1fPBr29msBOz62rfkHHzhTjWL8auxTcSSOzPPN
	 4HScabUEaWoYKivzHHXVfYZ9hCNs1+5Qb3rUdqUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Elizabeth Figura <zfigura@codeweavers.com>
Subject: [PATCH 6.18 485/675] selftests: ntsync: correct CONFIG_NTSYNC name
Date: Thu, 30 Jul 2026 16:13:35 +0200
Message-ID: <20260730141455.431414195@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ethan Nelson-Moore <enelsonmoore@gmail.com>

commit f97752cfe511c1ed9933057455c73aaac07d6517 upstream.

The config fragment for these tests defines CONFIG_WINESYNC, which
refers to an earlier name for the ntsync driver before it was merged
[1]. Correct it to define CONFIG_NTSYNC instead.

[1] https://lore.kernel.org/all/f4cc1a38-1441-62f8-47e4-0c67f5ad1d43@codeweavers.com/

Fixes: 7f853a252cde ("selftests: ntsync: Add some tests for semaphore state.")
Cc: stable <stable@kernel.org>
Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Reviewed-by: Elizabeth Figura <zfigura@codeweavers.com>
Link: https://patch.msgid.link/20260609175505.19632-1-enelsonmoore@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/drivers/ntsync/config |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/drivers/ntsync/config
+++ b/tools/testing/selftests/drivers/ntsync/config
@@ -1 +1 @@
-CONFIG_WINESYNC=y
+CONFIG_NTSYNC=y



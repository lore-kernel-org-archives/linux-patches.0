Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AAFE2CA9;
	Tue, 12 Aug 2025 18:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024482; cv=none; b=PClV0N7/em3AZPsRi14kf14pp2Uy0lanF3I/1gZyC8T/SnSgzSpCrwLuZrax3v/51l2XU0h8GT6YvxBtX/71vWZgFfvt6Ck7yPKnHwkDGT2kuTnaSBSnkEMkuoLYtU3iiZw8qED5tWHElCqIdC4wOw3yDbSm4lzlrinAu+E2mA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024482; c=relaxed/simple;
	bh=GShw35fQMbTg4q1zsnpv4yFsOkL+KIajbkS8tJljswk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCI5OViw0qM5i9HH/y/EcRTGh+ytKKwqawMBXD5Sk3InbpwDGb2NySsaju0m9hm+DfqjLQhDsMlr8l7W0oEKTzqsfrkSKrg/JKqvvb7GObamk/AybA9KgloI/7EvmOEd55AA3jyfrfpqyxPk+33YFau3ce/odlZu5MhXMxcMWWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ec145GWV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ec145GWV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF7DC4CEF0;
	Tue, 12 Aug 2025 18:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024482;
	bh=GShw35fQMbTg4q1zsnpv4yFsOkL+KIajbkS8tJljswk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ec145GWVJex6v4QTyu5eS3vLq11s4XbyuN4kHNOApsJVc5T1WJO9BbU8PVJx6biTz
	 y8uNi0hO2MQE4avWNyy1LJJsScfAn7M9oj9L/YAAHGg2X09nM/M2BjMeiwrQpFBRYS
	 yoi382WXThhHwXFUn+rOlAADXHVPUYhgbF/SNKYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WangYuli <wangyuli@uniontech.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 353/627] gitignore: allow .pylintrc to be tracked
Date: Tue, 12 Aug 2025 19:30:48 +0200
Message-ID: <20250812173432.718427838@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WangYuli <wangyuli@uniontech.com>

[ Upstream commit 38d573a624a54ccde1384ead8af0780fe4005c2b ]

The .pylintrc file was introduced by commit 02df8e3b333c ("docs: add a
.pylintrc file with sys path for docs scripts") to provide Python path
configuration for documentation scripts. However, the generic ".*" rule
in .gitignore causes this tracked file to be ignored, leading to warnings
during kernel builds.

Add !.pylintrc to the exception list to explicitly allow this
configuration file to be tracked by git, consistent with other
development tool configuration files like .clang-format and .rustfmt.toml.

This resolves the build warning:
  .pylintrc: warning: ignored by one of the .gitignore files

Fixes: 02df8e3b333c ("docs: add a .pylintrc file with sys path for docs scripts")
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Reviewed-by: Miguel Ojeda <ojeda@kernel.org>
Reviewed-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Link: https://lore.kernel.org/r/1A357750FF71847E+20250623071933.311947-1-wangyuli@uniontech.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index bf5ee6e01cd4..929054df5212 100644
--- a/.gitignore
+++ b/.gitignore
@@ -114,6 +114,7 @@ modules.order
 !.gitignore
 !.kunitconfig
 !.mailmap
+!.pylintrc
 !.rustfmt.toml
 
 #
-- 
2.39.5




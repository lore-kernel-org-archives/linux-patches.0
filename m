Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B7D1B4F0C;
	Wed, 19 Feb 2025 09:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957189; cv=none; b=str+mF7LwM7y/JtDIEgcMh/aup0m04YYUD4EisJoA/AqHDk9lOZ7CyTWtz6hDwy6lunYSD6xgBC/3AfCJKP2ewXsgjzoJ1kPXRTurLspfbwVHvorwd+G2mUklsN5D5K2KoENabYQyBM3CGSidb4MU56UPYjgLPrRiNWlalNT2k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957189; c=relaxed/simple;
	bh=i6xypo4IDQY/NNPeOmfMEay2AaEaBBvzDu/EBy8Bt6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fUgXiUYaQy6BMlNWOHq6usNSJnYPCLrtdinXYBAYXXjPhv78oHaJ4O3t/d4pQfAZgY37CT1+Ob0weXOGOL/XeOr1Tt39Hvv6DF1zD09L8LiCnqWdwvjuMhflod5ybFK8mYhY4qZkINnUyQ3rztt4QKK4iz6aB4esbadrNg0oIwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xgm4nGLb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xgm4nGLb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDFEC4CED1;
	Wed, 19 Feb 2025 09:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957189;
	bh=i6xypo4IDQY/NNPeOmfMEay2AaEaBBvzDu/EBy8Bt6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xgm4nGLbjY5EnCxMjWEkj07y+5wXGCJ/hbz7KV9zDk00cXj1mrAy6a72X0eFIPovb
	 d5skC2Ck/04DbJ6ghKXJP64Y4isaWyDXSw+wCFIVDja1lquTnhdfOlKWlw0jml+8ay
	 Vx6bdMeVoOBDJwwi+k6VjgglTFoRvb/m+zBO93G8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Kacur <jkacur@redhat.com>,
	Luis Goncalves <lgoncalv@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 439/578] rtla/osnoise: Distinguish missing workload option
Date: Wed, 19 Feb 2025 09:27:23 +0100
Message-ID: <20250219082710.275338860@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Glozar <tglozar@redhat.com>

commit 80d3ba1cf51bfbbb3b098434f2b2c95cd7c0ae5c upstream.

osnoise_set_workload returns -1 for both missing OSNOISE_WORKLOAD option
and failure in setting the option.

Return -1 for missing and -2 for failure to distinguish them.

Cc: stable@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>
Cc: Luis Goncalves <lgoncalv@redhat.com>
Link: https://lore.kernel.org/20250107144823.239782-2-tglozar@redhat.com
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/tracing/rtla/src/osnoise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/tracing/rtla/src/osnoise.c
+++ b/tools/tracing/rtla/src/osnoise.c
@@ -693,7 +693,7 @@ int osnoise_set_tracing_thresh(struct os
 
 	retval = osnoise_write_ll_config("tracing_thresh", tracing_thresh);
 	if (retval < 0)
-		return -1;
+		return -2;
 
 	context->tracing_thresh = tracing_thresh;
 



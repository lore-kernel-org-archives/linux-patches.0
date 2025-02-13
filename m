Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91D63D97A;
	Thu, 13 Feb 2025 14:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458378; cv=none; b=nMPcVCe5dHeqvF2ABMC+K9ouCt90TyR9JPH9P5B0pk1J8f4CflEAfhIvm9bnpbUlFc9VoOBVGyBpYje0glBfNhBmcIB47tKMN3ohWDDdRxdl95xQuAcDgOnOiDfCtRw58cALUgI+S3GkOev0s0lI33p/Nt1KiTUxqM2XIEx2XBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458378; c=relaxed/simple;
	bh=gYrTDg5Bp7cVI6Tpz8akgfmwe7YdJVUxnKjbIIaWcbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UtENw5HyHmLEZBKhQ35l++JW6xVOVR+hgXuHJMMB63+l6LuCka72Xhb/8i3PTAEQ2Wy5JsMR4lDOwHiytBRDBft3HXCA6CJrClhzpOR3VPU8103ldSSrefJUopXH59ELYi8qWLTFBVkKnz5Ppr+/uOnBnJRh0neqvKfvQgp93dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MElUoD1r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MElUoD1r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35249C4CEE4;
	Thu, 13 Feb 2025 14:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458378;
	bh=gYrTDg5Bp7cVI6Tpz8akgfmwe7YdJVUxnKjbIIaWcbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MElUoD1rOK7UbbfglP9p4OhZiUQSrfjYkyGL+IRWHEnER7g0hI37tjRXb6GJvGfDh
	 5mu8PSrySA5EUVjqilR5np/l2M8yy6edooa/yYm1z6ax9xqC0BELKVVzsjjpGuFbLt
	 sBbK/RgcAPiXQKWFhvy859jrTsICG5Y3l494+hq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Kacur <jkacur@redhat.com>,
	Luis Goncalves <lgoncalv@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 383/422] rtla/osnoise: Distinguish missing workload option
Date: Thu, 13 Feb 2025 15:28:52 +0100
Message-ID: <20250213142451.326878588@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -867,7 +867,7 @@ int osnoise_set_workload(struct osnoise_
 
 	retval = osnoise_options_set_option("OSNOISE_WORKLOAD", onoff);
 	if (retval < 0)
-		return -1;
+		return -2;
 
 	context->opt_workload = onoff;
 



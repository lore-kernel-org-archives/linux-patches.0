Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC33015A856;
	Thu, 13 Feb 2025 15:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460916; cv=none; b=AiVLswwxOQICaRyFEFGhjP7Rrb96LFrw/Yahc1QJY6W+40FTn4/msW4NaJ/xpfcwOdQIwBcbRPrpzSQPoIot5U7VIOOaySmvJTpLjqo60hyYyypUyzSBR5tJrBPpVt7zUapQj6AInIha5621DS+TvMmwH/IVEuNMQJ2WElYfdDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460916; c=relaxed/simple;
	bh=VudAjAyWaKHU41t6kaReMVVnk40CGGfolGEXpgTSVPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JxBnGuKM3O4rVS4lG1Nq4xImeTaoVBDSgihUD6DZe3hzsb1ugo9mZhkUMaKqvxVoZrlUv42c3aZhlwPqC9bw9t6a16Pc6DKSOUtTAnzuj8PqjBwlPaFc4CqxefSGAD6RsYQeW5A/NMUlTEZryiqctGscoxvH5SHerbmh5fa9UpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Loxi6Z1z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Loxi6Z1z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCF9C4CEE4;
	Thu, 13 Feb 2025 15:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460915;
	bh=VudAjAyWaKHU41t6kaReMVVnk40CGGfolGEXpgTSVPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Loxi6Z1znCFLhqfYHQK+vuZk5ifIWgB2AHzeKtP41g2vXy97cRvnh3AKNSi65CoJW
	 Z0Gx/GWF+Aa1AQQWWKaAI7qjgxI5+WkXYWqOcMtxLMpSNmKAGhStcI0SiR1e4wPcUh
	 qQpx2+kyABAElFJL0YL5/z1l5UrbebyjESLN6V7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Kacur <jkacur@redhat.com>,
	Luis Goncalves <lgoncalv@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 250/273] rtla/osnoise: Distinguish missing workload option
Date: Thu, 13 Feb 2025 15:30:22 +0100
Message-ID: <20250213142417.309617246@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F34D1BD018;
	Sun, 12 Jan 2025 15:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736695809; cv=none; b=oRCr2Gdny/DPjCDmW13yymNgTgJAh8IMBqClCnefnxMpi/eaf5+iCmdS3dASldjN8wWr4Th5bst3GPEe/Uy+A926ApdQoBery6V2OFlgOMNxyZvLJRou1acsG4MnVWcsX9WymdaPYgjRIcQdDpnJ+nTs7KLbqNrF5X/1HSgiAPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736695809; c=relaxed/simple;
	bh=l1I9Yt36Rmv0z3sY0Z2Jl/J4KHhtAuwtikLj3WiO3QQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/MlYkhdADsp1eiq8EBaPEbYbtmKIQKw3zzYr7tS5dqrHresbkkDLqQeY4Lv3693z4eeksvXUgxi+yJZ2HwSo8gJR0NapdStFgRD8KHi5lJOYjL4Jbj80k9kF1dwU51WzJwPwjv7fYS80ODPyIyxCgZadmgTNneGGdNn23M3rqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K2JLJCDW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K2JLJCDW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FACAC4CEE3;
	Sun, 12 Jan 2025 15:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736695808;
	bh=l1I9Yt36Rmv0z3sY0Z2Jl/J4KHhtAuwtikLj3WiO3QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K2JLJCDWj6IHxNyWd0L2kwcDSQ8NuKCvrW9bLHBGeBRj1JKb8cx+qhIf3WjkoSLbH
	 5UClx4itf2jgjtFM5ZKjixuPISnTpsOSjjBbMNJcIOjOmudHYX8kph0wd7iK4UNJjr
	 nsU/A1dexv2xD7ZyLadesKzRFmZ+NASpleutOP4jIKPXZyLiKHxOpEgR8l+v7E4w+5
	 aQ0gukMKEdRzX3tDqTruMmjVIP3pv/IzvLGozueOfbAJGa3nwet6OLwaUS928+yqST
	 Yia5Z4IdDBBYsRK/dR8RNg+1k0arGVH2K6M46B7BNlIosNc9oI11T8bNqpXWyWF+hT
	 WzK8m1yWkwJ3w==
From: Miguel Ojeda <ojeda@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: workflows@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Sami Tolvanen <samitolvanen@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	tech-board@groups.linuxfoundation.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2/3] docs: submitting-patches: clarify difference between Acked-by and Reviewed-by
Date: Sun, 12 Jan 2025 16:29:45 +0100
Message-ID: <20250112152946.761150-3-ojeda@kernel.org>
In-Reply-To: <20250112152946.761150-1-ojeda@kernel.org>
References: <20250112152946.761150-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Newcomers to the kernel need to learn the different tags that are
used in commit messages and when to apply them. Acked-by is sometimes
misunderstood, since the documentation did not really clarify (up to
the previous commit) when it should be used, especially compared to
Reviewed-by.

The previous commit already clarified who the usual providers of Acked-by
tags are, with examples. Thus provide a clarification paragraph for
the comparison with Reviewed-by, and give a couple examples reusing the
cases given above, in the previous commit.

Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Documentation/process/submitting-patches.rst | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/process/submitting-patches.rst b/Documentation/process/submitting-patches.rst
index c7a28af235f7..7b0ac7370cb1 100644
--- a/Documentation/process/submitting-patches.rst
+++ b/Documentation/process/submitting-patches.rst
@@ -480,6 +480,12 @@ mergers will sometimes manually convert an acker's "yep, looks good to me"
 into an Acked-by: (but note that it is usually better to ask for an
 explicit ack).
 
+Acked-by: is also less formal than Reviewed-by:.  For instance, maintainers may
+use it to signify that they are OK with a patch landing, but they may not have
+reviewed it as thoroughly as if a Reviewed-by: was provided.  Similarly, a key
+user may not have carried out a technical review of the patch, yet they may be
+satisfied with the general approach, the feature or the user-facing interface.
+
 Acked-by: does not necessarily indicate acknowledgement of the entire patch.
 For example, if a patch affects multiple subsystems and has an Acked-by: from
 one subsystem maintainer then this usually indicates acknowledgement of just
-- 
2.48.0


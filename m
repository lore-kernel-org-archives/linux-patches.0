Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6C01DF260;
	Wed,  6 Nov 2024 12:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894942; cv=none; b=aMGRmp4awoKBsg3CwPc0/qLvIqspjCiOYzJv5ZUhd3BchlLnNZXmpuqWUG53IHoGjUjZPUZc0giCAXNNi+3Fsi2Rj3s+KmZuzYPXvUkqYlwOewgRYCI3Hq3MlXLmYkaqLWY11EnbLcHLKT1W8fc4ZqYoMDsPjZqnFHdewHnEaIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894942; c=relaxed/simple;
	bh=9RG1DfPkzY7ZMGdjg/W+dkBiVg0x1NpXlwKxOuhV68A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ReaCs5Ir8DREqXAmTlhIRakT2AdV1wx5fVJ6GKzhsc9rHkjKAp6H1j+RcVVEEi/CBuizePn48ELvX+sgelOsv5VWO4ZjZ5H7tj07PvJumjclopiC+QuyX+QO0LVVfG+1deRNXfdB3PA32IgLrPj8ReTEBKOYrPlTpbkOj5C/S+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HvlhDkp8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HvlhDkp8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6F3C4CECD;
	Wed,  6 Nov 2024 12:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894941;
	bh=9RG1DfPkzY7ZMGdjg/W+dkBiVg0x1NpXlwKxOuhV68A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HvlhDkp8q/Qhq+41XNeu7npQgJB/mrBye0uqWyZMLYwq5ZHoMJhR1vuzOcOWZokdK
	 YF294ZQ1AFqhLWVcLuGpsL3lIczsSLymf8SruYCjQnF7Qs2qHyHBYLUOTZOO7bYumk
	 bdPiPvo8XTs+pMBbjyPUzaocun1rHM9HEdI+XZ+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Subject: [PATCH 4.19 014/350] selftests/kcmp: remove call to ksft_set_plan()
Date: Wed,  6 Nov 2024 12:59:02 +0100
Message-ID: <20241106120321.222151058@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>

The function definition for ksft_set_plan() is not present in linux-4.19.y.
kcmp_test selftest fails to compile because of this.

Fixes: 32b0469d13eb ("selftests/kcmp: Make the test output consistent and clear")
Signed-off-by: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Reviewed-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/kcmp/kcmp_test.c |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/testing/selftests/kcmp/kcmp_test.c
+++ b/tools/testing/selftests/kcmp/kcmp_test.c
@@ -89,7 +89,6 @@ int main(int argc, char **argv)
 		int ret;
 
 		ksft_print_header();
-		ksft_set_plan(3);
 
 		fd2 = open(kpath, O_RDWR);
 		if (fd2 < 0) {



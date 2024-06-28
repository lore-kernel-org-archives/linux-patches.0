Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B1FB645;
	Fri, 28 Jun 2024 15:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719588137; cv=none; b=JkBSxcwQY9C1N4fNOz5jJ8K6lHO/I6//oMiUMD8Wyu/MH1CMRpWLNecB+Ma5d25y8uVNQ+l4nX1bwK/yyq8Rt7iFgkAhkFv+aPBfn6YtDNlPQD/Wz/VLWytP+ekgnAwh3Bsh0T3VpF/nLnDSOj10er6Dln75rcGm0Xk3DVNDGAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719588137; c=relaxed/simple;
	bh=mlXfqSl4bNtK0Wc8tEDBT7aSmu1hPU4YcRHQXizWrTI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s52g0VERl8G+kg+lrsAkjSVZKSWcevZQ2Vy4JVzcjw2j/zE2oQe5oYajyKWPmi6KkPgeAnvvbgPmnRPX3WiPoorb37IJA1KhH/HInvLU5bVb33gTe9B+JPoOhVtSYOIrup6Xs2qxVUvS5i1LYJ4CP+iVuM62mdSySws0gHPGIKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S4fUwzaw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S4fUwzaw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53BFC116B1;
	Fri, 28 Jun 2024 15:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719588136;
	bh=mlXfqSl4bNtK0Wc8tEDBT7aSmu1hPU4YcRHQXizWrTI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=S4fUwzawnql/ZfMYqOkhkJE2Nat0g8GVbbwWnKtz6XOsYqVREkX0Jccr9arF7BTIe
	 2PgpWhj963kkfpCyw5oYkA0l99dJcw3LPAFaKiTWmACmcOUBuFPtWAAfIBOSDprkTx
	 BH//z7ufUyaIOw7g3LBPnVS1N8NthpDnQZ9tjGU4WNAJe2l+AtnRcFjVx30/9gS+gA
	 r7kjeAdVFFrpo80iDfk19Ap8OtR7HR4LBaylJCAGmbLNqCtIxHf5jdAzWHhgYOhEX2
	 RO3nZzCqR8WYDd/z0dBKszAqHqbFJHU2DhGg75WuEDmrmkbLU+6ZaeK/ttZiqI6PfR
	 IPza8BAtGw0sA==
Date: Fri, 28 Jun 2024 17:22:11 +0200
From: Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eric Woudstra
 <ericwouds@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Jiri Pirko
 <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>, Sasha Levin
 <sashal@kernel.org>
Subject: Re: [PATCH 6.9 029/250] net: sfp: enhance quirk for Fibrestore 2.5G
 copper SFP module
Message-ID: <20240628172211.17ccefe9@dellmb>
In-Reply-To: <20240625085549.174362251@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
	<20240625085549.174362251@linuxfoundation.org>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 25 Jun 2024 11:29:47 +0200
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> 6.9-stable review patch.  If anyone has any objections, please let me know.

Sorry I overlooked this, I thought I already replied to this, but in
fact I replied to another patch not to be backported:

  net: sfp: add quirk for another multigig RollBall transceiver
  https://lore.kernel.org/stable/20240527165441.2c5516c9@dellmb/

This patch (net: sfp: enhance quirk for Fibrestore 2.5G copper SFP
module) has the same problem: it depends on the same series, so it
should not be backported.

Eric informs me that it was already released as 6.9.7 :-(

What can we do?

Marek

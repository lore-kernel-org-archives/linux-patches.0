Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0049D64D;
	Sat, 24 May 2025 14:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748096289; cv=none; b=i7OLdMW9/nvHUU6UZyrDdIntxiV9BAA7q5ucjm5hVxNyj61ZXwcYPBXC91aiw2Ug3LxhEpkBj7tExq+S+SLSTWqyqrRKRFRbu6k3SAyCxVyUgxLpu78/WGCvsem3CJnedyR7mjqBB+eJd9HrFPUejtVvHbARKxar0Ml+2UPKigo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748096289; c=relaxed/simple;
	bh=QEyX9mg5w42738RO8LaL5c9rCGcjqtBlllc5NNb2u5c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fpnGZKql54AorBEV5tzsLE7q63e/n78Q651e92VJabQogYzBvH8DukpwjFlgVj2tT+RVwu0SRTWy9GCyaXBWJR9flr4QEO0b5d3yPCnMGG2YaaMiR8Nj/R+Y+DvYfJwlDLmKwHeZaCQa+gLxHWgEqyBOVXFieWSoB1kvga8SHcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ONIgFe8s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ONIgFe8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F20E7C4CEE4;
	Sat, 24 May 2025 14:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748096288;
	bh=QEyX9mg5w42738RO8LaL5c9rCGcjqtBlllc5NNb2u5c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ONIgFe8sB8bsYRmB/1y3leRkjbjdTF5z/xKv25ze0jpIzusSHNAULE3xadda+DNgs
	 E9FoyaY1xn+a18Mgqr9uglgbOqzAxxfPVhr9E4F4cIZpRTVRdWWdLWZrX2mYHeuEHU
	 Jr+ZS9fcxjECEKN1e+hlEqsr1Cg1KA0FjJAwY0N1jdFpe3QWfW/Ppz0pS5Pg0zSa3r
	 PxwsNqrjb6RYuwD6DvEQ2wTjJmKUS4fDen5MyXeU+h8qDjoorIjuELAD8b8BtgfWu2
	 8jhHcnGowGlaeKSciQ+Ef7LWUb1sJVS0SsGV5jfIbsE16MBSOd7hj5uyok1dQB2+o6
	 YFVPBRy7zf/Gw==
Message-ID: <9791eb90-95f6-43c7-93cd-1fe94b7128f3@kernel.org>
Date: Sat, 24 May 2025 16:18:03 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/10] rust: clean and enable Clippy `doc_markdown` lint
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Abdiel Janulgue <abdiel.janulgue@gmail.com>, Rob Herring
 <robh@kernel.org>, Saravana Kannan <saravanak@google.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Alex Gaynor
 <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>,
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Miguel Ojeda <ojeda@kernel.org>
References: <20250324210359.1199574-1-ojeda@kernel.org>
 <CANiq72mBHcsCpn1ZJRJ9Qa-Ass1MsoKdKcFpiFF7hNwyOXjAOA@mail.gmail.com>
Content-Language: en-US
From: Danilo Krummrich <dakr@kernel.org>
In-Reply-To: <CANiq72mBHcsCpn1ZJRJ9Qa-Ass1MsoKdKcFpiFF7hNwyOXjAOA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 21.05.2025 16:01, Miguel Ojeda wrote:
> On Mon, Mar 24, 2025 at 10:04 PM Miguel Ojeda <ojeda@kernel.org> wrote:
>>
>>   rust: alloc: add missing Markdown code spans
>>   rust: alloc: add missing Markdown code span
>>   rust: dma: add missing Markdown code span
>>   rust: of: add missing Markdown code span
>>   rust: pci: fix docs related to missing Markdown code spans
>>   rust: platform: fix docs related to missing Markdown code spans
>>   rust: task: add missing Markdown code spans and intra-doc links
> 
> Abdiel, Danilo, Rob, Saravana, Greg, Rafael: anything against me
> picking these ones up?

Acked-by: Danilo Krummrich <dakr@kernel.org>

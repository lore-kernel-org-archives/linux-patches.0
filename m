Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81E7366
	for <patches@lists.linux.dev>; Fri,  8 Apr 2022 05:02:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD29C385A3;
	Fri,  8 Apr 2022 05:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1649394178;
	bh=c5BG8Yf7jVbns77YNrWRs2tR3VlDsFRWtOmkAUqYVWk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=wMiCIUY9WUUKaSC99sjQYpchMHMfivFhD+dwQaY9eL8wRUxDsvy3bi9nwGAV4iNlq
	 ziK0flprQnJ8IfVuex73Y+gkFWG8eg7k5PgocQZe1qVhd6z+yWhFSBRLees5q5bwa6
	 Xtiwnj12SbLk7WHtx/88cxzugoJbCC/sJc6PtIT8=
Date: Fri, 8 Apr 2022 07:02:55 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Jithu Joseph <jithu.joseph@intel.com>
Cc: hdegoede@redhat.com, markgross@kernel.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, corbet@lwn.net,
	andriy.shevchenko@linux.intel.com, ashok.raj@intel.com,
	tony.luck@intel.com, rostedt@goodmis.org, dan.j.williams@intel.com,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, patches@lists.linux.dev,
	ravi.v.shankar@intel.com
Subject: Re: [PATCH v2 04/10] platform/x86/intel/ifs: Load IFS Image
Message-ID: <Yk/B/6wzC0O8dC24@kroah.com>
References: <20220407191347.9681-1-jithu.joseph@intel.com>
 <20220407191347.9681-5-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407191347.9681-5-jithu.joseph@intel.com>

On Thu, Apr 07, 2022 at 12:13:41PM -0700, Jithu Joseph wrote:
> IFS uses a scan image format that shares the same header as
> microcode updates and deployment approach for these images mirrors
> that of microcode update. Specifically, enable images to be deployed
> relative to a static symlink in /lib/firmware and then load
> into kernel memory via request_firmware().
> 
> The image is specific to a processor family, model and stepping.
> IFS requires that a test image be loaded before any ifs test is
> initiated. Load the image that matches processor signature.
> The IFS image is signed by Intel.
> 
> The IFS image file follows a similar naming convention as used for
> Intel CPU microcode files. The file must be located in the firmware
> directory where the microcode files are placed and named as {family/model
> /stepping}.scan as below:
> 
> /lib/firmware/intel/ifs/{ff-mm-ss}.scan

Is the firmware already submitted to the linux-firmware project for
inclusion there?

If not, where should a user get it from?

thanks,

greg k-h
